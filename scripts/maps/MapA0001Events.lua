local MapEvent        = require("app.map.MapEvent")
local MapEventHandler = require("app.map.MapEventHandler")

local MyMapEventHandler = class("MyMapEventHandler", MapEventHandler)

function MyMapEventHandler:preparePlay()
    MyMapEventHandler.super.preparePlay(self)

    self.createNextEnemyDelay_    = 1.0 -- 等待多少时间创建下一个敌人
    self.createNextEnemyInterval_ = 1.0 -- 创建下一个敌人前的间隔时间
end

function MyMapEventHandler:time(time, dt)
    MyMapEventHandler.super.time(self, time, dt)

    self.createNextEnemyDelay_ = self.createNextEnemyDelay_ - dt
    if self.createNextEnemyDelay_ <= 0 then
        self.createNextEnemyDelay_ = self.createNextEnemyDelay_ + self.createNextEnemyInterval_

        local state = {
            defineId = "EnemyShip01",
            behaviors = "NPCBehavior",
        }
        local enemy = self.runtime_:newObject("static", state)
        local pathId = string.format("path:%d", math.random(1, 2))
        enemy:bindPath(self.map_:getObject(pathId), 1)
        enemy:startMoving()
    end
end

function MyMapEventHandler:objectEnterRange(object, range)
    MyMapEventHandler.super.objectEnterRange(self, object, range)

    if object.defineId_ == "EnemyShip01" and range:getId() == "range:21" then
        self.runtime_:removeObject(object)
    end
end

return MyMapEventHandler
