_DEBUG_MODE = true

-- General Name
General_tanker_name = "Tanker"
General_AWACS_name = "AWACS"

-- Blue Default Name
Blue_tanker_name = "Tanker"
Blue_AWACS_name = "AWACS"
Blue_bomber_name = "B1-1"

-- Blue Init Unit
Blue_bomber = SPAWN:New(Blue_bomber_name)
Blue_tanker = SPAWN:New(Blue_tanker_name)
Blue_AWACS = SPAWN:New(Blue_AWACS_name)

-- Red Default Name
Red_CAP_name = "RED CAP"
Red_intercept_name = "RED intercept"

-- Red Init Unit
Red_CAP = SPAWN:New(Red_CAP_name)
Red_intercept = SPAWN:New(Red_intercept_name)

-- Event Handle Init
DeadEvent = EVENTHANDLER:New()
HitEvent = EVENTHANDLER:New()
CrashEvent = EVENTHANDLER:New()
PilotLandEvent = EVENTHANDLER:New()

DeadEvent:HandleEvent(EVENTS.Dead)
HitEvent:HandleEvent(EVENTS.Hit)
CrashEvent:HandleEvent(EVENTS.Crash)
PilotLandEvent:HandleEvent(EVENTS.LandingAfterEjection)

-- Ulity fucntion
function MesseageTo(to_who, type_messeage, message)
  if to_who == "blue" then
    MESSAGE:New(message, 10, type_messeage, false):ToBlue()
  elseif to_who == "red" then
    MESSAGE:New(message, 10, type_messeage, false):ToRed()
  elseif to_who == "all" then
    MESSAGE:New(message, 10, type_messeage, false):ToAll()
  end
end

function TeamFilter(EventData)
  local team
  if EventData.TgtCoalition == 2 then
    team = "blue"
  elseif EventData.TgtCoalition == 1 then
    team = "red"
  end

  return team
end

function RespawnMechanic(EventData, target_respawn)
  local team
  if EventData.TgtCoalition == 2 then
    team = "blue"
  elseif EventData.TgtCoalition == 1 then
    team = "red"
  end

  if target_respawn == General_tanker_name then
    if team == "red" then
    elseif team == "blue" then
    end
  elseif target_respawn == General_AWACS_name then
    if team == "red" then
    elseif team == "blue" then
    end
  end
end

function DebugOutput(EventData)
  if _DEBUG_MODE == true then
    BASE:I(EventData)
  end
end

-- Event Handle fucntion
function DeadEvent:OnEventDead(EventData)
  DebugOutput(EventData)
  local team = TeamFilter(EventData)
  MesseageTo("all", "INFO", "Dead Event")
end

function HitEvent:OnEventHit(EventData)
  DebugOutput(EventData)

  local team = TeamFilter(EventData)

  if string.find(EventData.IniGroupName, General_tanker_name) then
    MesseageTo(team, "INFO", "Our AWACS hit")
  elseif string.find(EventData.IniGroupName, General_AWACS_name) then
    MesseageTo(team, "INFO", "Our tanker hit")
  end
end

function CrashEvent:OnEventCrash(EventData)
  DebugOutput(EventData)

  local team = TeamFilter(EventData)

  if string.find(EventData.IniGroupName, General_tanker_name) then
    MesseageTo(team, "INFO", "Our AWACS down")
    Blue_AWACS:Spawn()
  elseif string.find(EventData.IniGroupName, General_AWACS_name) then
    MesseageTo(team, "INFO", "Our tanker down")
    Blue_tanker:Spawn()
  end
  MesseageTo("all", "INFO", "Crash Event")
end

function PilotLandEvent:OnEventLandingAfterEjection(EventData)
  DebugOutput(EventData)
  Unit.destroy(EventData.initiator)
end

-- Init fucntion
function Init()
  -- RED team
  Red_CAP:InitLimit(3, 4)
  Red_CAP:SpawnScheduled(5, .5)
  Red_CAP:InitRepeatOnLanding()

  Red_intercept:InitLimit(3, 4)
  Red_intercept:SpawnScheduled(5, .5)
  Red_intercept:InitRepeatOnLanding()

  -- BLUE team
  Blue_tanker:InitRepeatOnLanding()
  Blue_AWACS:InitRepeatOnLanding()

  -- Spawn
  Red_CAP:Spawn()
  Red_intercept:Spawn()
  Blue_tanker:Spawn()
  Blue_AWACS:Spawn()
end

function Main()
  -- ScheduleDispatcher = SCHEDULER:New(self, CheckBomber(), 1, 1, 1)
end

MesseageTo("all", "INFO", "Loaded v1.2 alpha")
Init()
-- TestMode(true)
-- Main()
