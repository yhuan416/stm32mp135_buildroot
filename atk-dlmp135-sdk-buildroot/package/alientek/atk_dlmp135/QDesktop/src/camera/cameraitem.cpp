#include "cameraitem.h"

CameraItem::CameraItem(QQuickItem *parent) : QQuickItem(parent)
{
    setFlag(ItemHasContents, true);

    captureThread = new CaptureThread(this);
    photoThread = new PhotoThread(this);
    m_imageThumb = QImage(640, 480, QImage::Format_RGB888);

    connect(captureThread, SIGNAL(resultReady(QImage)),
            this, SLOT(updateImage(QImage)));

    connect(captureThread, SIGNAL(sendImage(QImage)),
            photoThread, SLOT(whichPhotoNeedSave(QImage)));

    connect(photoThread, SIGNAL(finishSaveImage(QString)),
            this, SIGNAL(finishedPhoto(QString)));

    connect(captureThread, SIGNAL(finished()),
            this, SIGNAL(captureStop()));

    connect(captureThread, SIGNAL(cameraIsReady(bool)),
            this, SIGNAL(cameraIsReady(bool)));
}

void CameraItem::updateImage(QImage image)
{
    QMatrix leftmatrix;
    m_imageThumb = image.transformed(leftmatrix, Qt::SmoothTransformation);
    update();
}

CameraItem::~CameraItem()
{
    photoThread->quit();
    photoThread->wait();

    captureThread->setThreadStart(false);
    captureThread->quit();
    captureThread->wait();

    delete photoThread;
    delete captureThread;

    captureThread = nullptr;
    photoThread = nullptr;
}

void CameraItem::startCapture(bool start)
{
    if (!captureThread->isRunning())
        emit captureStop();
    captureThread->setThreadStart(start);
    if (start) {
        if (!captureThread->isRunning())
            captureThread->start();
    } else {
        captureThread->quit();
    }
}

void CameraItem::startPhotoGraph(bool photo)
{
    captureThread->setPhotoGraphFlag(photo);
}

void CameraItem::choseCamera(int camera)
{
    camerId = camera;
#ifdef __arm__

#endif
}

QSGNode * CameraItem::updatePaintNode(QSGNode *oldNode, QQuickItem::UpdatePaintNodeData *)
{
    auto node = dynamic_cast<QSGSimpleTextureNode *>(oldNode);

    if(!node){
        node = new QSGSimpleTextureNode();
    }

    QSGTexture *m_texture = window()->createTextureFromImage(m_imageThumb, QQuickWindow::TextureIsOpaque);
    node->setOwnsTexture(true);
    node->setRect(boundingRect());
    node->markDirty(QSGNode::DirtyForceUpdate);
    node->setTexture(m_texture);

    return node;
}
