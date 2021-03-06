
// third-party stuff
use dye
import dye/[core, math]

use gnaar
import gnaar/[utils, physics]

// sdk stuff
import math, math/Random

// our stuff
import isaac/[level, enemy, tear, utils]

FireBehavior: class {
    
    level: Level
    enemy: Enemy

    // state
    fireCount := 20

    // adjustable parameters
    fireCountMax := 60
    fireCountWiggle := 30
    fireSpeed := 200
    fireRadius := 300.0

    listener: FireListener

    targetType := TargetType RANDOM

    init: func (=enemy) {
        level = enemy level
    }

    onFire: func (f: Func) {
        listener = FireListener new(f)
    }

    update: func {
        if (fireCount > 0) {
            fireCount -= 1
        } else {
            if (fire()) {
                fireCount = fireCountMax + Random randInt(0, fireCountWiggle)
                if (listener) {
                    listener call()
                }
            }
            // else, wait for whatever we're shooting at to be in range
        }
    }

    fire: func -> Bool{
        dir := match targetType {
            case TargetType HERO =>
                diff := level hero pos sub(enemy pos)
                if (diff norm() > fireRadius) {
                    return false
                }

                diff normalized()
            case =>
                Vec2 random(100) normalized()
        }

        enemy spawnTear(enemy pos, dir, fireSpeed)
        true
    }

}

FireListener: class {

    f: Func

    init: func (=f)

    call: func { f() }

}

