# Apple Watch and BCI Controlled Mini

https://vimeo.com/316283833

![Apple Watch and BCI Controlled Mini](https://github.com/BrandlMax/watch-bci-controlled-mini/blob/master/images/Mini.jpg)

## Idea
The idea was to take an old remote controlled toy car and rebuild it so I could control it via API with my Apple Watch.
A scene from the James Bond movie Tomorrow Never Dies inspired this idea. Here Bond controls a 750 series BMW with his “Smartphone”. [https://youtu.be/W2ZbhElxeb4](https://youtu.be/W2ZbhElxeb4)

The whole thing I wanted to build up API based, so I could not only make it controllable via the Apple Watch but also could leave other possibilities of control open.

I also wanted to have a video transmission to control the car remotely as in the James Bond sequence.

## Structure
### Mini
I’m a big mini fan and had an old remote controlled model lying around. Unfortunately, it didn’t work anymore, so I dismantled it into its parts. What remained were the LED “headlights”, engine, steering motor, and horn. The brain of the Mini is a Raspberry Pi. It runs Raspian. For communication, I use “python-socketio”. The Raspberry is connected to a Pi camera for video transmission. For the power supply I use a power bank for the Raspberry and a 6 volt battery for the motors.

### iOS/Watch OS Application
The Apple Watch turned out to be a “bottleneck” during the project. From the speed and transfer rate. But with a few small tricks, you could run Socket.io directly on the Watch and play MJPEGs. Even if both are very unstable. In the end, it was possible to control the Mini with the Apple Watch.

For the control, I use the gyro sensor to drive to left or right, and I used the “crown” to speed up or slow down. With a Force-Touch you can also switch the light on and off, and also honking. 

### BCI with Brainfuck
Another project this semester was “BrainfuckJS” a BCI framework for the emotiv EPOC. With the help of this framework I could let the Mini drive with “thoughts” comparatively fast.

## Assembly Instructions
1. Insert the 6V battery
2. Connect the power bench to the Raspberry Pi
3. Setting up WLAN on the Raspberry Pi
4. Navigate to the ```Mini``` folder: \
```cd Mini```
5. Start script: \
```bash index.sh```


Now the Mini can be addressed via socket.

``` javascript
// INT between -100 - 100
socket.emit('speed', 0);

// INT between -100 - 100
socket.emit('direction', 100);

// Boolean
socket.emit('horn', true);

// Boolean
socket.emit('light', true);
```

## Obstacles and Problems
### Johnny Five Memory Leak
I lost a lot of time because I initially decided to use a Javascript solution with the JohnnyFive Library. However, this repeatedly led to a memory leak on the Pi, so it was no longer addressable after a few seconds.

Therefore, I rewrote everything in Python.
What I should have done from the beginning. The performance was much better.

### Apple Watch
However, the problem child of the project was the Apple Watch.
In the beginning I tried to make the video transmission via Homekit or Homebridge. However, the delay was not acceptable. Through the PiCamera I got an MJPEG stream. Unfortunately, there was no framework and no official way for the Apple Watch to integrate such a stream. Therefore, I had to rewrite one of the iOS frameworks. <br/> [https://github.com/WrathChaos/MJPEGStreamLib
](https://github.com/WrathChaos/MJPEGStreamLib)

So I finally got a video stream to the Apple Watch. However, the update rates are anything but satisfactory. But in the end you could actually control the Mini with the Apple Watch. And that’s pretty cool.

## Learnings
I’m taking a lot out of this project. I could gain new experience with the RaspberryPi. A great learning is, never to do a Raspberry project with Javascript anymore, only with Python. 

With every “Apple project” I learn the patience by painful hours to beat myself through thin documentaries. It surprised me that Socket ran on the Watch! This enables cool cross-platform projects with real-time interactions in the future.

After all, I am motivated to disassemble new things and breathe new life into them with RaspberryPis or ESPs.

## Code
[https://github.com/BrandlMax/watch-bci-controlled-mini
](https://github.com/BrandlMax/watch-bci-controlled-mini)

## Circuit Diagram
![Apple Watch and BCI Controlled Mini](https://github.com/BrandlMax/watch-bci-controlled-mini/blob/master/images/Schaltplan.png)



