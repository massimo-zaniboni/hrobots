BOARD
=====

* L'arena è di 1000x1000 basata in 0,0 in basso a sinistra
* gli angoli si misurano in gradi

              135    90   45
                  \  |  /
                   \ | /
             180 --- x --- 0
                   / | \
                  /  |  \
              225   270   315

* il robot occupa le sue coordinate, con una raggio di 1 (usato per il calcolo delle collisioni)

ROBOT
======

I robot sono configurabili: se uno aumenta la potenza dello sparo, poi deve calare l'accelerazione e cose simili.

Per ora si consiglia di farli partire con i parametri di default.

CANNONATE
=========

I proiettili si intendono in tiro balistico, quindi non vengono considerate le eventuali collisioni inaspettate con robot di passaggio,
 perché non vi sono, inquanto i colpi viaggiano più in alto.
I proiettili sparati fuori dall'arena esplodono fuori, non collidono coi bordi per lo stesso motivo di cui sopra.


    package game.netrobots.proto;
    
    // NOTE: for generating Python, and Java bindings:
    // > protoc -I=client --python_out=client client/netrobots.proto
    // > protoc -I=src --java_out=src src/netrobots.proto
    //
    // NOTE: for generating Haskell bindings:
    // > hprotoc -d src netrobots.proto 
    // 
    // NOTE: for other languages there are other similar commands to execute.
    
    
    message ScanStatus {
    
        //
        // The angle direction of the scan.
        //
        required int32 direction = 11;
    
        //
        // The angle of the scan cone identifying the scanned area.
        //
        required int32 semiaperture = 12;
    
        //
        // The distance of an object inside the scanned area.
        //
        required int32 distance = 13;
    }
    
    //
    // The status of a Robot.
    //
    message RobotStatus {
    
      // 
      // The name of the robot.
      //
      required string name = 1;
    
      //
      // A unique token identifying the robot inside the system.
      // Automatically assigned from the system.
      //
      required string token = 30;
    
      //
      // This status information is valid at this global simulation time.
      //
      required float globalTime = 21;
    
      //
      // The next command will be executed at globalTime + timeIncrement.
      // Usually it is a constant value for all the course of the simulation.
      //
      required float timeTick = 22;
    
      //
      // The real time in seconds, the sistem waits before processing the next request.
      // This differs from timeIncrement, because timeIncrement is the simulation time,
      // and maps the accuracy of the simulation/robot reaction, while this maps how much
      // the humans must wait for see the results.
      // This value can vary, and it depends from the speed of network connection between robots.
      // Usually it is a constant value.
      //
      required float realTimeTick = 23;
    
      //
      // Hit Points.
      //
      required int32 hp=2;
    
      //
      // The angle direction of the robot.
      //
      required int32 direction = 3;
    
      required int32 speed = 4;
    
      required int32 x = 5;
    
      required int32 y = 6;
    
      required bool isDead = 7;
    
      required bool isWinner= 8;
    
      //
      // True if the robot creation params respect the constraints.
      //
      required bool isWellSpecifiedRobot = 20;
    
      required int32 maxSpeed = 9;
    
      //
      // True if the robot can not fire immediately, because it is reloading the cannon.
      //
      required bool isReloading = 10;
    
      //
      // True if in the last robot command, the robot fired a missile.
      //
      required bool firedNewMissile = 15;
    
      //
      // This is the result of the last scan.
      // Compiled only if there were a scan command in the last robot request.
      //
      optional ScanStatus scan = 14;
    }
    
    //
    // Params used for creating a new Robot.
    // The value -1 is used for using default params.
    //
    message CreateRobot {
    
      //
      // The name of the robot.
      //
      required string name = 20;
    
      //
      // -1 for using default value.
      //
      required sint32 maxHitPoints = 10;
    
      //
      // -1 for using default value.
      //
      required sint32 maxSpeed = 11;
    
      //
      // -1 for using default value.
      //
      required sint32 acceleration = 12;
    
      //
      // -1 for using default value.
      //
      required sint32 decelleration = 13;
    
      //
      // -1 for using default value.
      //
      required sint32 maxSterlingSpeed = 14;
    
      //
      // -1 for using default value.
      //
      required sint32 maxScanDistance = 15;
    
      //
      // -1 for using default value.
      //
      required sint32 maxFireDistance = 16;
    
      //
      // -1 for using default value.
      //
      required sint32 bulletSpeed = 17;
    
      //
      // -1 for using default value.
      //
      required sint32 bulletDamage = 18;
    
      //
      // -1 for using default value.
      //
      required sint32 reloadingTime = 19;
    }
    
    message Cannon {
        required int32 direction = 1;
        required int32 distance = 2;
    }
    
    message Drive {
        required int32 speed = 3;
        required int32 direction = 4;
    }
    
    message Scan {
        required int32 direction = 5;
    
        //
        // The semi aperture in degree of the scanner.
        //
        required int32 semiaperture = 6;
    }
    
    //
    // Send a Command to a Robot with optional parts.
    //
    message RobotCommand {
    
      //
      // The unique identifier of the robot.
      //
      required string token = 11;
    
      optional Cannon cannon = 8;
      optional Scan scan = 9;
      optional Drive drive = 10;
    }
    
    message DeleteRobot {
      required string token = 1;
    }
    
    //
    // The main command to send to the server.
    //
    message MainCommand {
      optional CreateRobot createRobot = 1;
      optional RobotCommand robotCommand = 2;
      optional DeleteRobot deleteRobot = 3;
    }
                    
