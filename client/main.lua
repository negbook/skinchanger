Skin = {}
Skin.Components = {
  {label = _U('sex'),                   name = 'sex',           value = 0},
  {label = _U('face'),                  name = 'face',          value = 0},
  {label = _U('skin'),                  name = 'skin',          value = 0},
  {label = _U('wrinkles'),              name = 'age_1',         value = 0},
  {label = _U('wrinkle_thickness'),     name = 'age_2',         value = 0},
  {label = _U('beard_type'),            name = 'beard_1',       value = 0},
  {label = _U('beard_size'),            name = 'beard_2',       value = 0},
  {label = _U('beard_color_1'),         name = 'beard_3',       value = 0},
  {label = _U('beard_color_2'),         name = 'beard_4',       value = 0},
  {label = _U('hair_1'),                name = 'hair_1',        value = 0},
  {label = _U('hair_2'),                name = 'hair_2',        value = 0},
  {label = _U('hair_color_1'),          name = 'hair_color_1',  value = 0},
  {label = _U('hair_color_2'),          name = 'hair_color_2',  value = 0},
  {label = _U('eyebrow_size'),          name = 'eyebrows_2',    value = 0},
  {label = _U('eyebrow_type'),          name = 'eyebrows_1',    value = 0},
  {label = _U('eyebrow_color_1'),       name = 'eyebrows_3',    value = 0},
  {label = _U('eyebrow_color_2'),       name = 'eyebrows_4',    value = 0},
  {label = _U('makeup_type'),           name = 'makeup_1',      value = 0},
  {label = _U('makeup_thickness'),      name = 'makeup_2',      value = 0},
  {label = _U('makeup_color_1'),        name = 'makeup_3',      value = 0},
  {label = _U('makeup_color_2'),        name = 'makeup_4',      value = 0},
  {label = _U('lipstick_type'),         name = 'lipstick_1',    value = 0},
  {label = _U('lipstick_thickness'),    name = 'lipstick_2',    value = 0},
  {label = _U('lipstick_color_1'),      name = 'lipstick_3',    value = 0},
  {label = _U('lipstick_color_2'),      name = 'lipstick_4',    value = 0}
}
local LastSex     = -1
local LoadSkin    = nil
local Character   = {}
for i=1, #Components, 1 do
  Character[Components[i].name] = Components[i].value
end
Skin.LoadDefaultModel(malePed, cb)
  local characterModel
  if malePed then
    characterModel = GetHashKey('mp_m_freemode_01')
  else
    characterModel = GetHashKey('mp_f_freemode_01')
  end
  RequestModel(characterModel)
  Citizen.CreateThread(function()
    while not HasModelLoaded(characterModel) do
      RequestModel(characterModel)
      Citizen.Wait(0)
    end
    if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
      SetPlayerModel(PlayerId(), characterModel) -- new ped id 
	  local playerPed = PlayerPedId()
      SetPedDefaultComponentVariation(playerPed)
    end
    SetModelAsNoLongerNeeded(characterModel)
    if cb ~= nil then
      cb()
    end
    ClearPedProp(PlayerPedId(), 0)
  if LoadSkin ~= nil then
    Skin.ApplySkin(LoadSkin)
    LoadSkin = nil
  end
  end)
end
Skin.GetMaxVals = function()
  local playerPed = PlayerPedId()
  local data = {
    sex           = 332, -- or ped model
    face          = 45,
    skin          = 45,
    age_1         = GetNumHeadOverlayValues(3)-1,
    age_2         = 10,
    beard_1       = GetNumHeadOverlayValues(1)-1,
    beard_2       = 10,
    beard_3       = GetNumHairColors()-1,
    beard_4       = GetNumHairColors()-1,
    hair_1        = GetNumberOfPedDrawableVariations(playerPed, 2) - 1,
    hair_2        = GetNumberOfPedTextureVariations(playerPed, 2, Character['hair_1']) - 1,
    hair_color_1  = GetNumHairColors()-1,
    hair_color_2  = GetNumHairColors()-1,
    eyebrows_1    = GetNumHeadOverlayValues(2)-1,
    eyebrows_2    = 10,
    eyebrows_3    = GetNumHairColors()-1,
    eyebrows_4    = GetNumHairColors()-1,
    makeup_1      = GetNumHeadOverlayValues(4)-1,
    makeup_2      = 10,
    makeup_3      = GetNumHairColors()-1,
    makeup_4      = GetNumHairColors()-1,
    lipstick_1    = GetNumHeadOverlayValues(8)-1,
    lipstick_2    = 10,
    lipstick_3    = GetNumHairColors()-1,
    lipstick_4    = GetNumHairColors()-1
  }
  return data
end
Skin.ApplySkin = function(skin)
  local playerPed = PlayerPedId()
  for k,v in pairs(skin) do
    Character[k] = v
  end
  SetPedHeadBlendData     (playerPed, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
  SetPedHairColor         (playerPed,       Character['hair_color_1'],   Character['hair_color_2'])           -- Hair Color
  SetPedHeadOverlay       (playerPed, 3,    Character['age_1'],         (Character['age_2'] / 10) + 0.0)      -- Age + opacity
  SetPedHeadOverlay       (playerPed, 1,    Character['beard_1'],       (Character['beard_2'] / 10) + 0.0)    -- Beard + opacity
  SetPedHeadOverlay       (playerPed, 2,    Character['eyebrows_1'],    (Character['eyebrows_2'] / 10) + 0.0) -- Eyebrows + opacity
  SetPedHeadOverlay       (playerPed, 4,    Character['makeup_1'],      (Character['makeup_2'] / 10) + 0.0)   -- Makeup + opacity
  SetPedHeadOverlay       (playerPed, 8,    Character['lipstick_1'],    (Character['lipstick_2'] / 10) + 0.0) -- Lipstick + opacity
  SetPedComponentVariation(playerPed, 2,    Character['hair_1'],         Character['hair_2'], 2)              -- Hair
  SetPedHeadOverlayColor  (playerPed, 1, 1, Character['beard_3'],        Character['beard_4'])                -- Beard Color
  SetPedHeadOverlayColor  (playerPed, 2, 1, Character['eyebrows_3'],     Character['eyebrows_4'])             -- Eyebrows Color
  SetPedHeadOverlayColor  (playerPed, 4, 1, Character['makeup_3'],       Character['makeup_4'])               -- Makeup Color
  SetPedHeadOverlayColor  (playerPed, 8, 1, Character['lipstick_3'],     Character['lipstick_4'])             -- Lipstick Color
end

Skin.GetDatas = function(cb)
  local components = json.decode(json.encode(Skin.Components))
  for k,v in pairs(Character) do
    for i=1, #components, 1 do
      if k == components[i].name then
        components[i].value = v
        --components[i].zoomOffset = Components[i].zoomOffset
        --components[i].camOffset = Components[i].camOffset
      end
    end
  end
  cb(components, Skin.GetMaxVals())
end)
Skin.SetCharacterSkin = function(key, val)
  Character[key] = val
  if key == 'sex' then
    Skin.LoadCharacterSkin(Character)
  else
    Skin.ApplySkin(Character)
  end
end)
Skin.GetCharacterSkin function(cb)
  cb(Character)
end)

Skin.LoadCharacterSkin = function(skin, cb)
  local characterModel
  if skin['sex'] ~= LastSex then
    LoadSkin = skin
    if skin['sex'] == 0 then
      Skin.LoadDefaultModel( true, cb)
   	elseif skin['sex'] > 1 then
	    characterModel = pedList[skin.sex - 1]
    else --skin['sex'] == 1
      Skin.LoadDefaultModel( false, cb)
    end
  RequestModel(characterModel)
  else
    Skin.ApplySkin(skin)
    if cb ~= nil then
      cb()
    end
  end
  LastSex = skin['sex']
  Citizen.CreateThread(function()
    while not HasModelLoaded(characterModel) do
      RequestModel(characterModel)
      Citizen.Wait(0)
    end
    if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
      SetPlayerModel(PlayerId(), characterModel) --new ped id 
	  local playerPed = PlayerPedId()
      SetPedDefaultComponentVariation(playerPed)
    end
    SetModelAsNoLongerNeeded(characterModel)
    ClearPedProp(PlayerPedId(), 0)
	  if LoadSkin ~= nil then
		Skin.ApplySkin(LoadSkin)
		LoadSkin = nil
	  end
  end)
end)