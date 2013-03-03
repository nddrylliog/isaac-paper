

// third-party stuff
use deadlogger
import deadlogger/[Log, Logger]

use chipmunk
import chipmunk

use dye
import dye/[core, sprite, primitives, math]

use gnaar
import gnaar/[utils]

// our stuff
import isaac/[level]


Tear: class extends Entity {

    range := 100.0

    pos, vel: Vec2

    body: CpBody
    shape: CpShape

    sprite: GlSprite

    init: func (.level, .pos, .vel) {
        super(level)

        this pos = vec2(pos)
        this vel = vec2(vel)

        sprite = GlSprite new("assets/png/tears-1.png")
        sprite scale set!(0.5, 0.5)
        level group add(sprite)

        initPhysx()
    }

    update: func -> Bool {
        sprite sync(body)
    }

    initPhysx: func {
        radius := 16.0
        mass := 2.0

        moment := cpMomentForCircle(mass, 0, radius, cpv(radius, radius))

        body = CpBody new(mass, moment)
        body setPos(cpv(pos))
        body setVel(cpv(vel))
        level space addBody(body)

        shape = CpCircleShape new(body, radius, cpv(0, 0))
        shape setUserData(this)
    }

    destroy: func {
        level space removeShape(shape)
        level space removeBody(body)
        level group remove(sprite)
    }

}