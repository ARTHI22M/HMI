/****************************************************************************
**
** Copyright (C) 2019 The Qt Company Ltd.
** Contact: https://www.qt.io/licensing/
**
** This file is part of the examples of the Qt Toolkit.
**
** $QT_BEGIN_LICENSE:BSD$
** Commercial License Usage
** Licensees holding valid commercial Qt licenses may use this file in
** accordance with the commercial license agreement provided with the
** Software or, alternatively, in accordance with the terms contained in
** a written agreement between you and The Qt Company. For licensing terms
** and conditions see https://www.qt.io/terms-conditions. For further
** information use the contact form at https://www.qt.io/contact-us.
**
** BSD License Usage
** Alternatively, you may use this file under the terms of the BSD license
** as follows:
**
** "Redistribution and use in source and binary forms, with or without
** modification, are permitted provided that the following conditions are
** met:
**   * Redistributions of source code must retain the above copyright
**     notice, this list of conditions and the following disclaimer.
**   * Redistributions in binary form must reproduce the above copyright
**     notice, this list of conditions and the following disclaimer in
**     the documentation and/or other materials provided with the
**     distribution.
**   * Neither the name of The Qt Company Ltd nor the names of its
**     contributors may be used to endorse or promote products derived
**     from this software without specific prior written permission.
**
**
** THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
** "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
** LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR
** A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
** OWNER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
** SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT
** LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE,
** DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY
** THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
** (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
** OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE."
**
** $QT_END_LICENSE$
**
****************************************************************************/

import QtQuick
import QtQuick3D



Model {
    property int sp:0;
    property var splitValues: [];

    function resetRobot() {
            console.log("reset robot")

            baseAnimation.from = base.eulerRotation.y;
            baseAnimation.to = 0;
            baseAnimation.velocity=sp;

            rootAnimation.from = root.eulerRotation.z;
            rootAnimation.to = 0;
            rootAnimation.velocity=sp;

            forearmAnimation.from = forearm.eulerRotation.x;
            forearmAnimation.to = 0;
            forearmAnimation.velocity=sp;

            armAnimation.from = arm.eulerRotation.x;
            armAnimation.to = 0;
            armAnimation.velocity=sp;

            hand_hingeAnimation.from = hand_hinge.eulerRotation.x;
            hand_hingeAnimation.to = 0;
            hand_hingeAnimation.velocity=sp;

            hand_grab_b_hinge_1.eulerRotation.x = 0;

            baseAnimation.start();
            rootAnimation.start();
            forearmAnimation.start();
            armAnimation.start();
            hand_hingeAnimation.start();
        }

    // ...

    Timer {
        id: animationTimer
        interval: 50000/sp
        repeat: true
        running: true

        property int currentCol: 0
        property bool isAnimating: false

        function startAnimation() {
            console.log("start animation called")
            if (!isAnimating) {
                resetRobot();
                isAnimating = true;
                currentCol = 0;
                animationTimer.restart();
            }
        }

        function stopAnimation() {
            console.log("stop animation called")
            if (isAnimating) {
                isAnimating = false;
                resetRobot();
                animationTimer.stop();
            }
        }

        onTriggered: {
            if (currentCol < ((splitValues[0].length)-1)) {
                console.log("Iteration " + (currentCol + 1) + ":");

                baseAnimation.from = base.eulerRotation.y;
                baseAnimation.to = splitValues[0][currentCol];
                console.log(splitValues[0][currentCol]);
                baseAnimation.velocity = sp;

                rootAnimation.from = root.eulerRotation.z;
                rootAnimation.to = splitValues[1][currentCol];
                console.log(splitValues[1][currentCol]);
                rootAnimation.velocity = sp;

                forearmAnimation.from = forearm.eulerRotation.x;
                forearmAnimation.to = splitValues[2][currentCol];
                console.log(splitValues[2][currentCol]);
                forearmAnimation.velocity = sp;

                armAnimation.from = arm.eulerRotation.x;
                armAnimation.to = splitValues[3][currentCol];
                console.log(splitValues[3][currentCol]);
                armAnimation.velocity = sp;

                hand_hingeAnimation.from = hand_hinge.eulerRotation.x;
                hand_hingeAnimation.to = splitValues[4][currentCol];
                console.log(splitValues[4][currentCol]);
                hand_hingeAnimation.velocity = sp;

                baseAnimation.running = true;
                rootAnimation.running = true;
                forearmAnimation.running = true;
                armAnimation.running = true;
                hand_hingeAnimation.running = true;

                hand_grab_b_hinge_1.eulerRotation.x = splitValues[5][currentCol];
                console.log(splitValues[5][currentCol]);

                console.log('-----------------');

                currentCol++;
            } else {
                stopAnimation();
            }
        }
    }

    // ...


    function animation(data) {
            console.log(data);

            for (let i = 0; i < data.length; i++) {
                var inputArray = data[i].split(',');
                console.log(inputArray);
                splitValues.push(inputArray);
            }

            // Start the animation by starting the timer
             animationTimer.startAnimation();
        }


    id: base
    scale.x: 50
    scale.y: 50
    scale.z: 50
    source: "qrc:/assets/base.mesh"
    eulerRotation.x: -90
    eulerRotation.y:0
    Connections {
        target: bridge

        onRadioButton1Clicked:{
            console.log("joint1")
        }
        onDegreevalue1: {
            //console.log("joint1", degree1)

            baseAnimation.from = base.eulerRotation.y;
            baseAnimation.to = degree1;
            baseAnimation.velocity=speed
            baseAnimation.start();

        }

    }
    Connections{
        target: backend
        onAnimate:{

            animation(anidata);
            console.log(anidata);

        }
        onSpeedchange:{
            console.log(value)
            sp=value
        }
    }


    SmoothedAnimation {
        id: baseAnimation
        property: "eulerRotation.y"
        target: base

    }




    property variant material
    materials: [ material ]
    Model {
        id: root
        y: -5.96047e-08
        z: 1.0472
        eulerRotation.z:0;
        source: "qrc:/assets/root.mesh"
        Connections {
            target: bridge

            onRadioButton2Clicked:{
                console.log("joint2")
            }
            onDegreevalue2:{
                console.log("joint2",degree2)
                rootAnimation.from = root.eulerRotation.z; // Update the animation's start value
                rootAnimation.to = degree2;
                rootAnimation.velocity=speed
                rootAnimation.start();

            }
        }
        SmoothedAnimation {
            id: rootAnimation
            property: "eulerRotation.z"
            target: root

        }
        materials: [ material ]
        Model {
            id: forearm
            x: 5.32907e-15
            y: -0.165542
            z: 1.53472
            eulerRotation.x: 0;
            source: "qrc:/assets/forearm.mesh"

           materials: [ material ]

            Connections {
                target: bridge

                onRadioButton3Clicked:{
                    console.log("joint3")
                }
                onDegreevalue3:{
                    console.log("joint3",degree3)
                    forearmAnimation.from = forearm.eulerRotation.x; // Update the animation's start value
                    forearmAnimation.to = degree3;
                    forearmAnimation.velocity=speed
                    forearmAnimation.start();
                }
            }
            SmoothedAnimation {
                id: forearmAnimation
                property: "eulerRotation.x"
                target: forearm

            }

            Model {
                id: arm
                x: -7.43453e-07
                y: 0.667101
                z: 2.23365
                eulerRotation.x: 0;
                source: "qrc:/assets/arm.mesh"
                materials: [ material ]
                Connections {
                    target: bridge

                    onRadioButton4Clicked:{
                        console.log("joint4")
                    }
                    onDegreevalue4:{
                        console.log("joint4",degree4)
                        armAnimation.from = arm.eulerRotation.x; // Update the animation's start value
                        armAnimation.to = degree4;
                        armAnimation.velocity=speed
                        armAnimation.start();
                    }
                }
                SmoothedAnimation {
                    id: armAnimation
                    property: "eulerRotation.x"
                    target: arm

                }

                Model {
                    id: hand_hinge
                    x: 7.43453e-07
                    y: 0.0635689
                    z: 2.12289
                    eulerRotation.x:0;
                    source: "qrc:/assets/hand_hinge.mesh"
                    materials: [ material ]
                    Connections {
                        target: bridge

                        onRadioButton5Clicked:{
                            console.log("joint5")
                        }
                        onDegreevalue5:{
                            console.log("joint5",degree5)
                            hand_hingeAnimation.from = arm.eulerRotation.x; // Update the animation's start value
                            hand_hingeAnimation.to = degree5;
                            hand_hingeAnimation.velocity=speed
                            hand_hingeAnimation.start();
                        }
                    }
                    SmoothedAnimation {
                        id: hand_hingeAnimation
                        property: "eulerRotation.x"
                        target: hand_hinge

                    }

                    Model {
                        id: hand
                        x: 3.35649e-06
                        y: 2.38419e-07
                        z: 0.366503
                        source: "qrc:/assets/hand.mesh"
                        materials: [ material ]

                        Model {
                            id: hand_grab_t_hinge_2
                            x: -9.5112e-07
                            y: 0.323057
                            z: 0.472305
                            eulerRotation: hand_grab_t_hinge_1.eulerRotation
                            source: "qrc:/assets/hand_grab_t_hinge_2.mesh"
                            materials: [ material ]
                        }

                        Model {
                            id: hand_grab_t_hinge_1
                            x: -9.3061e-07
                            y: 0.143685
                            z: 0.728553
                            //eulerRotation.x: hand_grab_b_hinge_1.eulerRotation.x
                            source: "qrc:/assets/hand_grab_t_hinge_1.mesh"
                            materials: [ material ]


                            Model {
                                id: hand_grab_t
                                x: -2.42588e-06
                                y: -0.0327932
                                z: 0.414757
                                eulerRotation.x: hand_grab_t_hinge_1.eulerRotation.x * -1
                                source: "qrc:/assets/hand_grab_t.mesh"
                                materials: [ material ]
                            }
                        }

                        Model {
                            id: hand_grab_b_hinge_1
                            x: -9.38738e-07
                            y: -0.143685
                            z: 0.728553

                            source: "qrc:/assets/hand_grab_b_hinge_1.mesh"
                            materials: [ material ]
                            Connections {
                                target: bridge

                                onRadioButton6Clicked:{
                                    console.log("joint6")
                                }
                                onDegreevalue6:{
                                    console.log("joint6",degree6)
                                    hand_grab_b_hinge_1.eulerRotation.x=degree6

                                }
                            }


                            Model {
                                id: hand_grab_b
                                x: -2.41775e-06
                                y: 0.0327224
                                z: 0.413965
                                eulerRotation.x: hand_grab_b_hinge_1.eulerRotation.x * -1
                                source: "qrc:/assets/hand_grab_b.mesh"
                                materials: [ material ]
                            }
                        }
                        Model {
                            id: hand_grab_b_hinge_2
                            x: -9.5112e-07
                            y: -0.323058
                            z: 0.472305
                            eulerRotation.x: hand_grab_b_hinge_1.eulerRotation.x
                            source: "qrc:/assets/hand_grab_b_hinge_2.mesh"
                            materials: [ material ]

                        }
                    }
                }
            }
        }
    }

}

