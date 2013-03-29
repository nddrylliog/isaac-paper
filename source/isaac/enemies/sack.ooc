
// third-party stuff
use deadlogger
import deadlogger/[Log, Logger]

use chipmunk
import chipmunk

use dye
import dye/[core, sprite, primitives, math]

use gnaar
import gnaar/[utils]

// sdk stuff
import math, math/Random

// our stuff
import isaac/[level, shadow, enemy, hero, utils, paths]
import isaac/enemies/[spider]

/*
 * Spiderer.
 */
Sack: class extends Mob {

    spawnCount := 200
    spawnCountMax := 140
    radius := 180

    damage := 4.0

    maxLife := 30.0
    lifeIncr := 0.04

    init: func (.level, .pos) {
        super(level, pos)

        life = maxLife

        loadSprite("sack", level charGroup)
        createShadow(30)

        createBox(20, 20, INFINITY, INFINITY)
    }

    getSpriteName: func -> String {
        "sack"
    }

    fixed?: func -> Bool {
        true
    }

    touchHero: func (hero: Hero) -> Bool {
        // we only spawn spiders, we don't hurt per se
        true
    }

    update: func -> Bool {
        if (life < maxLife) {
           if (damageCount <= 0) {
                life += lifeIncr
           }
        } else {
            if (spawnCount > 0) {
                dist := level hero pos dist(pos)
                if (dist < radius) {
                    spawnCount -= Random randInt(1, 2)
                }
            } else {
                spawn()
            }
        }

        scale := 0.8 * life / maxLife
        sprite scale set!(scale, scale)
        shadow setScale(scale)

        if (life <= 8.0) {
            return false
        }

        super()
    }

    spawn: func {
        spider := Spider new(level, pos, SpiderType SMALL)
        spider catapult()
        level add(spider)
        resetSpawnCount()
    }

    resetSpawnCount: func {
        spawnCount = spawnCountMax + Random randInt(-20, 120)
    }

    destroy: func {
        super()
    }

    harm: func (damage: Float) {
        super(damage)
        resetSpawnCount()
    }

}
