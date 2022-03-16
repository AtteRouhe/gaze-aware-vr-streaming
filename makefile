360-video-to-cubemap:
	ffmpeg -i video/input.mp4 -vf "v360=equirect:c6x1:out_forder=rludfb" video/cubemap.mp4

# seperate single cube from cubemap
crop-front:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:0:0" video/front_cube.mp4
	
crop-back:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:480:0" video/back_cube.mp4

crop-right:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:960:0" video/right_cube.mp4

crop-left:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:1440:0" video/left_cube.mp4

crop-up:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:1920:0" video/up_cube.mp4

crop-down:
	ffmpeg -i video/cubemap.mp4 -filter:v "crop=480:480:2400:0" video/down_cube.mp4

# use yaw to specify rotation (eg 90 for right, -90 for left FOV)
cubemap-to-rotated-stero:
	ffmpeg -i cubemap.mp4 -vf "v360=c6x1:sg:yaw=0:out_stereo=sbs" stereo-front.mp4

# encode to different bitstreams
encode-1:
	ffmpeg -i stereo-front.mp4 -s 160x90 -c:v libx264 -b:v 250k -g 90 -an stereo_front_160x90_250k.mp4

encode-2:
	ffmpeg -i stereo-front.mp4 -s 320x180 -c:v libx264 -b:v 500k -g 90 -an stereo_front_320x180_500k.mp4

encode-audio:
	ffmpeg -i stereo-front.mp4 -c:a aac -b:a 128k -vn stereo_audio_128k.mp4

# configure for dash, also makes mpd file
dashify:
	mp4box -dash 5000 -rap -profile dashavc264:onDemand -mpd-title BBB -out manifest.mpd -frag 2000 cubemap_audio_128k.mp4 cubemap_160x90_250k.mp4 cubemap_320x180_500k.mp4
