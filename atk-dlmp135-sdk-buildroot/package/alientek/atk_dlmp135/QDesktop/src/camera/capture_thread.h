/******************************************************************
Copyright © Deng Zhimao Co., Ltd. 2021-2030. All rights reserved.
* @projectName   desktop
* @brief         capture_thread.h
* @author        Deng Zhimao
* @email         dengzhimao@alientek.com
* @link          www.openedv.com
* @date          2021-09-22
*******************************************************************/
#ifndef CAPTURE_THREAD_H
#define CAPTURE_THREAD_H

#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <stdio.h>
#include <unistd.h>
#include <string.h>
#include <pthread.h>
#ifdef linux
#include <linux/fb.h>
#include <sys/ioctl.h>
#include <sys/mman.h>
#include <linux/videodev2.h>
#include <linux/input.h>
#endif

#include <QThread>
#include <QDebug>
#include <QPushButton>
#include <QImage>
#include <QByteArray>
#include <QBuffer>
#include <QTime>
#include <QQuickItem>

#define VIDEO_DEV			"/dev/video0"
#define FB_DEV				"/dev/fb0"
#define VIDEO_BUFFER_COUNT	3

struct buffer_info {
    void *start;
    unsigned int length;
};

class CaptureThread : public QThread
{
    Q_OBJECT

signals:
    void resultReady(QImage);

    void sendImage(QImage);

    void cameraIsReady(bool);

private:

    bool startFlag = false;
    bool photoGraphFlag = false;

public:
    CaptureThread(QObject *parent = nullptr) {
        Q_UNUSED(parent);
    }

    void setThreadStart(bool start) {
        startFlag = start;
    }

    void setPhotoGraphFlag(bool photo) {
        photoGraphFlag = photo;
    }

    void run() override {
#ifdef __arm__

        QFile file("/dev/media0");
        if (!file.exists()) {
          emit  cameraIsReady(false);
            return;
        }
         emit  cameraIsReady(true);

        system("media-ctl -d /dev/media0 --set-v4l2 \"'ov5640 1-003c':0[fmt:RGB565_2X8_LE/640x480@1/30 field:none]\"");

        int fb_fd = -1;
        int video_fd = -1;
        struct v4l2_format fmt;
        struct v4l2_requestbuffers req_bufs;
        static struct v4l2_buffer buf;
        int n_buf;
        struct buffer_info bufs_info[VIDEO_BUFFER_COUNT];
        enum v4l2_buf_type type;

        fb_fd = open(FB_DEV, O_RDWR);
        if (0 > fb_fd) {
            printf("ERROR: failed to open framebuffer device %s\n", FB_DEV);
            return ;
        }

        video_fd = open(VIDEO_DEV, O_RDWR);
        if (0 > video_fd) {
            printf("ERROR: failed to open video device %s\n", VIDEO_DEV);
            return ;
        }

        fmt.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        fmt.fmt.pix.width = 640;
        fmt.fmt.pix.height = 480;
        //fmt.fmt.pix.colorspace = V4L2_COLORSPACE_SRGB;
        //fmt.fmt.pix.pixelformat = V4L2_PIX_FMT_RGB565;

        //system("media-ctl -d /dev/media0 --set-v4l2 \"'ov5640 1-003c':0[fmt:RGB565_2X8_LE/640x480@1/30 field:none]\"");

        if (0 > ioctl(video_fd, VIDIOC_S_FMT, &fmt)) {
            printf("ERROR: failed to VIDIOC_S_FMT\n");
            close(video_fd);
            return ;
        }

        req_bufs.count = VIDEO_BUFFER_COUNT;
        req_bufs.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        req_bufs.memory = V4L2_MEMORY_MMAP;

        if (0 > ioctl(video_fd, VIDIOC_REQBUFS, &req_bufs)) {
            printf("ERROR: failed to VIDIOC_REQBUFS\n");
            return ;
        }

        buf.type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        buf.memory = V4L2_MEMORY_MMAP;
        for (n_buf = 0; n_buf < VIDEO_BUFFER_COUNT; n_buf++) {

            buf.index = n_buf;
            if (0 > ioctl(video_fd, VIDIOC_QUERYBUF, &buf)) {
                printf("ERROR: failed to VIDIOC_QUERYBUF\n");
                return ;
            }

            bufs_info[n_buf].length = buf.length;
            bufs_info[n_buf].start = mmap(NULL, buf.length,
                                          PROT_READ | PROT_WRITE, MAP_SHARED,
                                          video_fd, buf.m.offset);
            if (MAP_FAILED == bufs_info[n_buf].start) {
                printf("ERROR: failed to mmap video buffer, size 0x%x\n", buf.length);
                return ;
            }
        }

        for (n_buf = 0; n_buf < VIDEO_BUFFER_COUNT; n_buf++) {

            buf.index = n_buf;
            if (0 > ioctl(video_fd, VIDIOC_QBUF, &buf)) {
                printf("ERROR: failed to VIDIOC_QBUF\n");
                return ;
            }
        }

        type = V4L2_BUF_TYPE_VIDEO_CAPTURE;
        if (0 > ioctl(video_fd, VIDIOC_STREAMON, &type)) {
            printf("ERROR: failed to VIDIOC_STREAMON\n");
            return ;
        }

        while (startFlag) {

            for (n_buf = 0; n_buf < VIDEO_BUFFER_COUNT; n_buf++) {

                buf.index = n_buf;

                if (0 > ioctl(video_fd, VIDIOC_DQBUF, &buf)) {
                    printf("ERROR: failed to VIDIOC_DQBUF\n");
                    return;
                }

                QImage qImage((unsigned char*)bufs_info[n_buf].start, fmt.fmt.pix.width, fmt.fmt.pix.height, QImage::Format_RGB16);

                emit resultReady(qImage);
                if (photoGraphFlag) {
                    if (qImage.isNull())
                        return;
                    photoGraphFlag = false;
                    emit sendImage(qImage);
                }

                if (0 > ioctl(video_fd, VIDIOC_QBUF, &buf)) {
                    printf("ERROR: failed to VIDIOC_QBUF\n");
                    return;
                }
            }
        }

        msleep(800);//at lease 650

        for (int i = 0; i < VIDEO_BUFFER_COUNT; i++) {
            munmap(bufs_info[i].start, buf.length);
        }

        close(video_fd);
#endif
    }
};

#endif // CAPTURE_THREAD_H
