import QtQuick 2.15
import QtQuick.Controls 2.16
import QtQuick.Layouts 1.15
import QtQuick.Controls.Material 2.12
import Qt5Compat.GraphicalEffects
import QtQuick3D
import Qt3D.Extras 2.2

ApplicationWindow{
    height:900
    width:1200
    visible:true

    function onHomeClicked() {
        console.log("Home clicked")

    }

    function onProductsClicked() {
        customvariable.open()
    }

    function onAboutClicked() {
        program.open()


    }
    function retrieveDataForAllItems() {
        for (var i = 0; i < selectedItemsListView.model.count; i++) {
            var itemName = selectedItemsListView.model.get(i).name;
            backend.checkAndRetrieveData(itemName);
        }

        backend.insertdata(customTextField.text);


    }
    Rectangle{
        id:rect1

        width: parent.width *0.5
        height: parent.height

        anchors.left: parent.left
        View3D {
            anchors.fill: parent

            environment: SceneEnvironment {
                clearColor: "#808080"
                backgroundMode: SceneEnvironment.Color
                antialiasingMode: SceneEnvironment.MSAA
                antialiasingQuality: SceneEnvironment.High
            }


            PerspectiveCamera {
                id: perspectiveCamera
                position: Qt.vector3d(20, 700, 600)
                clipFar: 2000
                eulerRotation.x: -30
                eulerRotation.y:slider5.sliderValue
            }

            //! [directional light]
            DirectionalLight {
                id: light1
                color: Qt.rgba(1.0, 1.0, 1.0, 1.0)

                ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
                position: Qt.vector3d(0, 200, 0)
                rotation: Quaternion.fromEulerAngles(-135, -90, 0)
                //shadowMapQuality: Light.ShadowMapQualityHigh
                visible: checkBox1.checked
                //castsShadow: checkBoxShadows.checked
                brightness: slider1.sliderValue
                SequentialAnimation on rotation {
                    loops: Animation.Infinite
                    QuaternionAnimation {
                        to: Quaternion.fromEulerAngles(-45, -90, 0)
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                    QuaternionAnimation {
                        to: Quaternion.fromEulerAngles(-135, -90, 0)
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            //! [directional light]

            //! [point light]
            PointLight {
                id: light2
                color: Qt.rgba(1.0, 1.0, 1.0, 1.0)
                ambientColor: Qt.rgba(0.1, 0.1, 0.1, 1.0)
                position: Qt.vector3d(0, 300, 0)
                visible: checkBox2.checked
                brightness: slider2.sliderValue
                SequentialAnimation on x {
                    loops: Animation.Infinite
                    NumberAnimation {
                        to: 400
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                    NumberAnimation {
                        to: 0
                        duration: 2000
                        easing.type: Easing.InOutQuad
                    }
                }
            }
            //! [point light]

            //! [spot light]
            SpotLight {
                id: light4
                color: Qt.rgba(1.0, 0.9, 0.7, 1.0)
                ambientColor: Qt.rgba(0.0, 0.0, 0.0, 0.0)
                position: Qt.vector3d(0, 250, 0)
                eulerRotation.x: -45
                shadowMapFar: 2000
                shadowMapQuality: Light.ShadowMapQualityHigh
                visible: checkBox4.checked
                castsShadow: checkBoxShadows.checked
                brightness: slider4.sliderValue
                coneAngle: 50
                innerConeAngle: 30
                PropertyAnimation on eulerRotation.y {
                    loops: Animation.Infinite
                    from: 0
                    to: -360
                    duration: 10000
                }
            }
            //! [spot light]

            //! [rectangle models]
            Model {
                source: "#Rectangle"
                y: -200
                scale: Qt.vector3d(15, 15, 15)
                eulerRotation.x: -90
                materials: [
                    DefaultMaterial {
                        diffuseColor: Qt.rgba(0.8, 0.6, 0.4, 1.0)
                    }
                ]
            }
            Model {
                source: "#Rectangle"
                z: -400
                scale: Qt.vector3d(15, 15, 15)
                materials: [
                    DefaultMaterial {
                        diffuseColor: Qt.rgba(0.8, 0.8, 0.9, 1.0)
                    }
                ]
            }
            //! [rectangle models]
            Robot {
                id:robot

                //visible: !checkBoxCustomMaterial.checked

                material: DefaultMaterial {

                   diffuseColor: Qt.rgba(0.6, 0.2, 1.0, 1.0)
                }



            }



        }

        Frame {
            anchors.top: parent.top
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 5
            background: Rectangle {
                color: "#e0e0e0"
                border.color: "#000000"
                border.width: 1
                opacity: 0.8
            }
            Column {
                id: settingsArea



                Item { width: 1; height: 10 }
                CustomCheckBox {
                    id: checkBox1
                    text: qsTr("Directional Light")
                    checked: true
                }
                CustomSlider {
                    id: slider1
                    sliderValue: 0.5
                    fromValue: 0
                    toValue: 1
                }
                Item { width: 1; height: 10 }
                CustomCheckBox {
                    id: checkBox2
                    text: qsTr("Point Light")
                    checked: false
                }
                CustomSlider {
                    id: slider2
                    sliderValue: 6
                    fromValue: 0
                    toValue: 10
                }
                Item { width: 1; height: 10 }
                CustomCheckBox {
                    id: checkBox4
                    text: qsTr("Spot Light")
                    checked: false
                }
                CustomSlider {
                    id: slider4
                    sliderValue: 10
                    fromValue: 0
                    toValue: 30
                }
                Item { width: 1; height: 40 }
                CustomCheckBox {
                    id: checkBox5
                    text: qsTr("Camera Pitch")
                    checked: false
                }
                CustomSlider {
                    id: slider5
                    sliderValue: 0 // Initialize the slider value
                    fromValue: -180 // Minimum value
                    toValue: 180    // Maximum value
                    onSliderValueChanged: {
                        var angle = slider5.sliderValue * Math.PI / 180;
                        perspectiveCamera.position = Qt.vector3d(
                                    Math.cos(angle) * 700,
                                    700,
                                    Math.sin(angle) * 700
                                    );
                        perspectiveCamera.eulerRotation.y = slider5.sliderValue;
                        perspectiveCamera.lookAt(robot.position);
                    }
                }


            }
        }






    }
    Rectangle{
        id:rect2
        color:"black"


        width: parent.width *0.5
        height: parent.height
        //Material.elevation: 10
        anchors.left: rect1.right
        anchors.top: parent.top
        Rectangle{
            width:parent.width
            height:100
            //Material.elevation: 10
            anchors.top:parent.top
            color:"black"

            Text {
                id: textItem
                anchors.centerIn: parent
                text: ""
                anchors.horizontalCenter:log.center
                font.pixelSize: 50
                color:"purple"


            }

            Timer {
                id: typingTimer
                interval: 500
                repeat: true
                running: true

                property int currentIndex: 0
                property string fullText: "HMI CONTROLLER"

                onTriggered: {
                    textItem.text = fullText.substring(0, currentIndex);
                    currentIndex++;

                    if (currentIndex > fullText.length)
                        currentIndex = 0;
                }
            }


            Rectangle {
                width:50
                height:50
                color:"transparent"
                anchors.right: parent.right
                anchors.topMargin: 5
                Image {
                    id: drawerimage
                    source: "qrc:/images/icon.png"
                    anchors.centerIn: parent
                }


                MouseArea{
                    anchors.fill: parent


                    onClicked: drawer.visible = !drawer.visible
                }
            }

            Drawer {
                id: drawer
                width: parent.width/4
                height: parent.height

                Rectangle {
                    width: parent.width
                    height: parent.height
                    color:"purple"
                    gradient: Gradient {
                        GradientStop { position: 0.0; color:"#4228E2" }
                        GradientStop { position: 0.5; color: "#9537EA"  }
                        GradientStop { position: 1.0; color:"#D843F0" }

                    }
                    Rectangle{
                        id:space
                        width: parent.width
                        height: 200
                        anchors.top: parent.top
                        color:"transparent"
                    }

                    ListView {
                        width: parent.width
                        height: parent.height
                        model: ["Home", "Custom Variable", "Program"]
                        anchors.top: space.bottom
                        delegate: Item {
                            width: parent.width
                            height: 100

                            Rectangle {
                                width: parent.width
                                height: 100
                                color: ListView.isCurrentItem ? Material.accentColor : "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData
                                    color: Material.foregroundColor
                                    font.pixelSize:25
                                }

                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        if (modelData === "Home")
                                            onHomeClicked();
                                        else if (modelData === "Custom Variable")
                                            onProductsClicked();
                                        else if (modelData === "Program")
                                            onAboutClicked();

                                        drawer.close();
                                    }
                                }
                            }
                        }
                    }
                }

                edge: Qt.RightEdge
                modal: false
            }



        }


        Rectangle{
            id:circle1
            width: parent.width *0.5
            height: parent.width *0.5
            radius: parent.width *0.25
            anchors.left: parent.left
            anchors.leftMargin:40
            anchors.verticalCenter: parent.verticalCenter

            color: "transparent"
            border.color: "purple"
            border.width: 5

            Glow {
                id: glowEffect1
                source: circle2
                radius: 20
                spread:  60
                color: "purple"
                anchors.fill: circle2
                ColorAnimation on color { from: "purple"; to: "#6D33A6"; duration:2000;loops:Animation.Infinite }
            }

            Rectangle {
                id: circle2
                width: parent.width
                height: parent.width
                radius: parent.width/2
                color: "transparent"
                border.color: "purple"
                border.width: 1



            }
            Rectangle{
                id:degree
                width: parent.width *0.6
                height: parent.width *0.6
                radius: parent.width *0.3
                anchors.centerIn:parent
                //color: "purple"



                gradient: Gradient {
                    GradientStop { position: 0.0; color:"#4228E2" }
                    GradientStop { position: 0.5; color: "#9537EA"  }
                    GradientStop { position: 1.0; color:"#D843F0" }

                }


                Rectangle{
                    width:30
                    height:30
                    radius:15
                    anchors.bottom: degreetext.top
                    anchors.topMargin: 15
                    anchors.bottomMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "purple"
                    Text {
                        id:degreeincrease
                        text: qsTr("+")
                        font.pixelSize: 25
                        anchors.centerIn: parent
                        color: "lavender"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            degreetext.text = (parseInt(degreetext.text) + 5);
                        }
                    }
                }


                TextField {
                    id:degreetext

                    horizontalAlignment: TextInput.AlignHCenter
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    text: "0"
                    //anchors.centerIn: parent
                    font.pixelSize:40
                    color:"purple"
                    anchors.centerIn: parent
                    Binding {
                        target: degreetext
                        property: "text"
                        value: parseFloat(degreetext.text) > 180 ? "180" :
                                                                   parseFloat(degreetext.text) < -180 ? "-180" :
                                                                                                        degreetext.text
                    }
                    onTextChanged: {
                        if(joint1.checked){
                            bridge.degreevalue1(degreetext.text,speedtext.text);
                            j1.text=String(degreetext.text)
                        }
                        else if(joint2.checked){
                            bridge.degreevalue2(degreetext.text,speedtext.text);
                            j2.text=String(degreetext.text)
                        }
                        else if(joint3.checked){
                            bridge.degreevalue3(degreetext.text,speedtext.text);
                            j3.text=String(degreetext.text)
                        }
                        else if(joint4.checked){
                            bridge.degreevalue4(degreetext.text,speedtext.text);
                            j4.text=String(degreetext.text)
                        }
                        else if(joint5.checked){
                            bridge.degreevalue5(degreetext.text,speedtext.text);
                            j5.text=String(degreetext.text)
                        }
                        else if(joint6.checked){
                            bridge.degreevalue6(degreetext.text,speedtext.text);
                            j6.text=String(degreetext.text)
                        }
                    }
                }
                Rectangle{
                    width:30
                    height:30
                    radius:15
                    anchors.top: degreetext.bottom
                    anchors.topMargin: 10
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "purple"
                    Text {
                        id:degreedecrease
                        text: qsTr("-")
                        font.pixelSize: 35
                        anchors.centerIn: parent
                        color: "lavender"
                    }
                    MouseArea{
                        anchors.fill: parent
                        onClicked: {
                            degreetext.text = (parseInt(degreetext.text) - 5);
                        }
                    }
                }


            }


            RadioButton {
                id:joint1
                text: "J1"
                anchors.top: parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.topMargin:parent.width*0.05
                width:parent.width/5
                height:parent.height/9
                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint1.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint1.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint1.down ? "purple" : "purple"
                        visible:joint1 .checked
                    }
                }
                contentItem: Text {
                    text: joint1.text
                    font: joint1.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint1.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint1.indicator.width + joint1.spacing
                }
                onClicked:{
                    bridge.radioButton1Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }
            }
            RadioButton {
                id:joint2
                text:"J2"
                anchors.top:parent.top
                anchors.right: parent.right
                anchors.topMargin:parent.height*0.25
                anchors.rightMargin: parent.width*0.05
                width:parent.width/5
                height:parent.height/9
                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint2.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint2.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint2.down ? "purple" : "purple"
                        visible:joint2 .checked
                    }
                }
                contentItem: Text {
                    text: joint2.text
                    font: joint2.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint2.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint2.indicator.width + joint2.spacing
                }
                onClicked:{
                    bridge.radioButton2Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }


            }
            RadioButton {
                id:joint3
                text:"J3"
                anchors.bottom:parent.bottom
                anchors.right: parent.right
                anchors.bottomMargin:parent.height*0.25
                anchors.rightMargin:parent.width*0.05

                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint3.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint3.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint3.down ? "purple" : "purple"
                        visible:joint3 .checked
                    }
                }
                contentItem: Text {
                    text: joint3.text
                    font: joint3.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint3.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint3.indicator.width + joint3.spacing
                }

                onClicked: {
                    // Emit the C++ signal to trigger the action in C++
                    bridge.radioButton3Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }



            }
            RadioButton {
                id:joint4
                anchors.bottom:parent.bottom
                text:"J4"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin:parent.width*0.02
                width:parent.width*0.2
                height:parent.height*0.2
                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint4.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint4.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint4.down ? "purple" : "purple"
                        visible:joint4.checked
                    }
                }
                contentItem: Text {
                    text: joint4.text
                    font: joint4.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint4.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint4.indicator.width + joint4.spacing
                }

                onClicked: {

                    bridge.radioButton4Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }


            }
            RadioButton {
                id:joint5
                text:"J5"
                anchors.bottom:parent.bottom
                anchors.left: parent.left
                anchors.bottomMargin:parent.height*0.25
                anchors.leftMargin:parent.width*0.1
                width:parent.width/5
                height:parent.height/9
                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint5.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint5.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint5.down ? "purple" : "purple"
                        visible:joint5 .checked
                    }
                }
                contentItem: Text {
                    text: joint5.text
                    font: joint5.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint5.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint5.indicator.width + joint5.spacing
                }

                onClicked: {

                    bridge.radioButton5Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }



            }
            RadioButton {
                id:joint6
                text:"J6"
                anchors.top:parent.top
                anchors.left: parent.left
                anchors.topMargin:parent.height*0.25
                anchors.leftMargin:parent.width*0.05
                width:parent.width/5
                height:parent.height/9
                indicator: Rectangle {
                    implicitWidth: 26
                    implicitHeight: 26
                    x: joint6.leftPadding
                    y: parent.height / 2 - height / 2
                    radius: 13
                    border.color: joint6.down ? "purple" : "purple"

                    Rectangle {
                        width: 14
                        height: 14
                        x: 6
                        y: 6
                        radius: 7
                        color: joint6.down ? "purple" : "purple"
                        visible:joint6 .checked
                    }
                }
                contentItem: Text {
                    text: joint6.text
                    font: joint6.font
                    opacity: enabled ? 1.0 : 0.3
                    color: joint6.down ? "white" : "purple"
                    verticalAlignment: Text.AlignVCenter
                    leftPadding: joint6.indicator.width + joint6.spacing
                }

                onClicked: {

                    bridge.radioButton6Clicked(checked);

                }
                onCheckedChanged: {
                    degreetext.text="0"
                }


            }




        }


        Rectangle{
            id:speed
            width: parent.width *0.4
            height: parent.width *0.4
            radius: parent.width *0.2
            anchors.left:circle1.right
            anchors.leftMargin:30
            anchors.verticalCenter: parent.verticalCenter
            color: "transparent"
            Image {
                id: ellipse_half
                x: 216
                y: 107
                width: 203
                height: 191
                source: "qrc:/images/ellipse_half.png"
                anchors.centerIn: parent
                fillMode: Image.PreserveAspectFit

                Image {
                    id: unionremovebgpreview
                    x: 89
                    y: 63
                    width: 36
                    height: 108
                    source: "qrc:/images/union-removebg-preview.png"
                    //rotation: 0.851
                    fillMode: Image.PreserveAspectFit
                    transform: Rotation {
                        id: needleRotation
                        origin.x: 5; origin.y: 65
                        //! [needle angle]
                        angle: Math.min(Math.max(-130, speedtext.value*6 - 130), 130)
                        Behavior on angle {
                            SpringAnimation {
                                spring: 1.4
                                damping: .15
                            }
                        }
                        //! [needle angle]
                    }
                }
            }


            Rectangle{
                width: 31
                height: 29
                anchors.top: ellipse_half.bottom
                anchors.left: ellipse_half.left
                color:"transparent"
                Image {
                    id: speeddecrease
                    x: 388
                    y: 286
                    width: parent.width
                    height: parent.height
                    source: "qrc:/images/-.png"
                    anchors.centerIn: parent

                    fillMode: Image.PreserveAspectFit
                }
                MouseArea{
                    anchors.fill: parent
                   onClicked: {
                        speedtext.text = (parseInt(speedtext.text) - 1);
                    }
                }
            }
            Rectangle{
                width: 50
                height: 30
                color:"transparent"
                anchors.top: ellipse_half.bottom
                anchors.horizontalCenter: ellipse_half.horizontalCenter
                Text {
                    id:speedtext
                    horizontalAlignment: TextInput.AlignHCenter
                    anchors.centerIn: parent
                    property real value : 0
                    text: "0"

                    font.pixelSize:30
                    color:"purple"
                    onTextChanged: {
                        value=parseInt(speedtext.text)
                        backend.speedchange(value);
                    }

                }
            }
            Rectangle{
                width: 32
                height: 23
                color:"transparent"

                anchors.top: ellipse_half.bottom
                anchors.right: ellipse_half.right
                Image {
                    id: speedincrease
                    x: 216
                    y: 286
                    width: parent.width
                    height: parent.height
                    source: "qrc:/images/+.png"
                    anchors.centerIn: parent
                    fillMode: Image.PreserveAspectFit
                }
                MouseArea{
                    anchors.fill: parent
                    onClicked: {
                        speedtext.text = (parseInt(speedtext.text) + 1);
                    }
                }
            }

        }



        Popup {
            id: customvariable
            width: parent.width*0.5
            height: parent.height*0.7
            anchors.centerIn: parent
            closePolicy: Popup.NoAutoClose
            modal:true



            TextField {

                anchors.topMargin: 10
                id: nameField
                placeholderText: "     Enter custom variable name"
                width: parent.width - 40
                height:parent.height*0.1

            }

            GridLayout {
                columns: 2
                rowSpacing: 10
                columnSpacing: 10
                anchors.centerIn: parent

                Label {
                    text: "J1"
                }
                TextField {
                    id:j1
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j1
                        property: "text"
                        value: parseFloat(j1.text) > 180 ? "180" :
                                                           parseFloat(j1.text) < -180 ? "-180" :
                                                                                        j1.text
                    }
                }

                Label {
                    text: "J2"
                }
                TextField {
                    id:j2
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j2
                        property: "text"
                        value: parseFloat(j2.text) > 180 ? "180" :
                                                           parseFloat(j2.text) < -180 ? "-180" :
                                                                                        j2.text
                    }
                }

                Label {
                    text: "J3"
                }
                TextField {
                    id:j3
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j3
                        property: "text"
                        value: parseFloat(j3.text) > 180 ? "180" :
                                                           parseFloat(j3.text) < -180 ? "-180" :
                                                                                        j3.text
                    }
                }

                Label {
                    text: "J4"
                }
                TextField {
                    id:j4
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: TextInput.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j4
                        property: "text"
                        value: parseFloat(j4.text) > 180 ? "180" :
                                                           parseFloat(j4.text) < -180 ? "-180" :
                                                                                        j4.text
                    }
                }

                Label {
                    text: "J5"
                }
                TextField {
                    id:j5
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j5
                        property: "text"
                        value: parseFloat(j5.text) > 180 ? "180" :
                                                           parseFloat(j5.text) < -180 ? "-180" :
                                                                                        j5.text
                    }
                }

                Label {
                    text: "J6"
                }
                TextField {
                    id:j6
                    width: 70
                    validator: RegularExpressionValidator { regularExpression: /^-?\d+(\.\d+)?$/ }
                    color: "purple"
                    horizontalAlignment: Text.AlignHCenter
                    font.pixelSize: 25
                    background: Rectangle {
                        height: 50
                        width:70
                        color: "lavender"
                        border.color: "gray"
                        border.width: 1
                        radius: 5
                    }
                    Binding {
                        target: j6
                        property: "text"
                        value: parseFloat(j6.text) > 180 ? "180" :
                                                           parseFloat(j6.text) < -180 ? "-180" :
                                                                                        j6.text
                    }
                }
            }

            RowLayout {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 25
                spacing: 10

                Button {
                    text: "Save"
                    onClicked:{classA.store(nameField.text,j1.text,j2.text,j3.text,j4.text,j5.text,j6.text)}

                }

                Button {
                    text: "Close"
                    onClicked: {
                        customvariable.close()
                    }
                }
            }
            Connections {
                target: classA

                onSave:{
                    insertsucces.open();
                }
            }
            Popup {
                id:insertsucces
                anchors.centerIn: Overlay.overlay
                width: 300
                height: 100
                modal: true
                focus: true

                Text {
                    id: error
                    text: qsTr("Successfully inserted")
                    font.pixelSize: 15
                    anchors.horizontalCenter:parent.horizontalCenter
                    color: "purple"

                }
                Button {
                    text: qsTr("ok")
                    highlighted: true

                    anchors.top:  error.bottom
                    anchors.horizontalCenter:parent.horizontalCenter
                    onClicked: {

                        insertsucces.close()


                    }


                }
            }


        }
        Popup {
            id: program
            width: parent.width*0.5
            height: parent.height*0.7
            anchors.centerIn: parent
            closePolicy: Popup.NoAutoClose
            modal:true

            Frame {
                width:parent.width*0.98
                height:parent.height*0.8
                anchors.margins: 50
                background: Rectangle {
                    color: "transparent"
                    border.color: "transparent"


                }

                ScrollView {
                    anchors.fill: parent
                    ListView {
                        id:programlist
                        width: parent.width
                        height: parent.height

                        model:{
                            backend.showdata();
                            //OndataUpdated:backend.showdata();

                        }

                        anchors.top:space.bottom
                        delegate: Item {
                            width: parent.width
                            height: 100

                            Rectangle {
                                width: parent.width
                                height: 100
                                color: "transparent"

                                Text {
                                    anchors.centerIn: parent
                                    text: modelData

                                    font.pixelSize:20
                                    color:"#D843F0"
                                }
                                Component.onCompleted: {
                                           backend.dataUpdate.connect(updateModel); // Connect to the signal
                                       }
                                MouseArea {
                                    anchors.fill: parent
                                    onClicked: {
                                        backend.animationdata(modelData);
                                        program.close();


                                    }
                                }
                            }
                        }
                    }
                }





            }


            RowLayout {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 25
                spacing: 10
                Button {
                    text: "Create new project"
                    onClicked:createprogram.open()

                }

                Button {
                    text: "Close"
                    onClicked: {
                        program.close()
                    }
                }
            }
        }
        Popup {
            id: createprogram
            width: parent.width*0.5
            height: parent.height*0.7
            anchors.centerIn: parent

            closePolicy: Popup.NoAutoClose
            modal:true
            ComboBox {
                id: comboBox1
                width: parent.width*0.9
                displayText: "Select an item"

                onActivated: {
                    selectedItemsListView.model.append({name: comboBox1.currentText})
                }

                model: prog.getdata();

                onModelChanged: {
                    comboBox1.displayText = "Select an item"; // Reset displayText when model changes
                }

                onCurrentIndexChanged: {
                       if (currentIndex === -1) {
                           comboBox1.displayText = "Select an item"; // Reset displayText when ComboBox becomes idle
                       }
                   }

                Connections {
                    target: prog
                    onDataAdded: {
                        comboBox1.displayText = "Select an item"; // Reset displayText when new data is added
                    }
                }
            }

            Frame {
                width:parent.width*0.98
                height:parent.height*0.7
                anchors.top:comboBox1.bottom

                background: Rectangle {
                    color: "transparent"
                    border.color: "purple"
                }
                ScrollView{
                    anchors.fill: parent
                    TextField {
                        id: customTextField
                        width:parent.width
                        placeholderText: "Enter Program Name"
                    }


                    ListView {
                        id: selectedItemsListView
                        width: parent.width
                        height: parent.height*0.9
                        spacing: 10
                        anchors.top:customTextField.bottom
                        model: ListModel{}
                        delegate: Item {
                            width: parent.width
                            height: 40

                            Rectangle {
                                width: parent.width - cancelButton.width
                                height: parent.height
                                color: "lavender"
                                border.color: "black"

                                Text {
                                    anchors.centerIn: parent
                                    text: model.name
                                    font.pixelSize: 14
                                }
                            }

                            Button {
                                id: cancelButton
                                width: 40
                                height: parent.height
                                text: "\u2716"
                                anchors.leftMargin: 25
                                anchors.right: parent.right
                                onClicked: {
                                    selectedItemsListView.model.remove(index)
                                }
                            }
                        }

                    }
                }

            }
            RowLayout {
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottomMargin: 25
                spacing: 10

                Button {
                    text: "Save"
                    // anchors.top: customTextField.bottom
                    onClicked: {
                        retrieveDataForAllItems();
                    }

                }



                Button {
                    text: "Close"
                    onClicked: {
                        createprogram.close()
                    }
                }
            }
        }

    }
}

