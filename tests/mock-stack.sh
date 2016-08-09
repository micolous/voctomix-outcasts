#!/bin/bash -ex

gst-launch-1.0 \
    tcpserversrc host=127.0.0.1 port=4953 ! \
    tcpserversink host=127.0.0.1 port=4954  &

gst-launch-1.0 \
            videotestsrc name=videosrc ! \
     mux. \
            audiotestsrc  name=audiosrc ! \
     mux. \
            matroskamux name=mux ! \
    tcpclientsink host=127.0.0.1 port=4953 &

gst-launch-1.0 \
    tcpclientsrc host=127.0.0.1 port=4954 !\
	matroskademux name=demux \
	demux. !\
		queue !\
		videoconvert !\
		avenc_mpeg2video bitrate=5000000 max-key-interval=0 !\
		queue !\
		mux. \
	demux. !\
		queue !\
		audioconvert !\
		avenc_mp2 bitrate=192000 !\
		queue !\
		mux. \
	mpegtsmux name=mux !\
		filesink location="/tmp/test.ts"

