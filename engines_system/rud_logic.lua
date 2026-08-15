-- simple RUD logic for Tu-154M (No Delay Version_xp12)jeni
-- ОБНОВЛЕНО для X-Plane 12: заменён устаревший датареф barometer_sealevel_inhg
--FIX prm engine !!! 1\05\26
--local forward_table = {
--    { -10000, 0.00  },
--    {   0.0,  0.38  },  -- малый газ: 0,42 номин. (КВД 59.5-61.5% по РЛЭ)
--    {   0.5,  0.55  },  -- 0,6 номин.
--    {   0.6,  0.637 },  -- между 0,6 и 0,7 номин.
--    {   0.65, 0.72  },  -- 0,7 номин.
--    {   0.7,  0.805 },  -- номинальный
--    {   0.8,  0.886 },
--    {   1.0,  0.975 },  -- взлётный
--    {   1.1,  1.0   },
--    {   1.2,  1.2   },
--    { 100000, 1.3   }
--FIX

-- sim/version/xplane_internal_version
defineProperty("xp_version", globalPropertyi("sim/version/xplane_internal_version"))

-- controls
defineProperty("tro_comm_1", globalPropertyf("sim/custom/SC/engine/ENGN_thro_0")) 
defineProperty("tro_comm_2", globalPropertyf("sim/custom/SC/engine/ENGN_thro_1")) 
defineProperty("tro_comm_3", globalPropertyf("sim/custom/SC/engine/ENGN_thro_2"))

defineProperty("sim_rud_1", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[0]"))
defineProperty("sim_rud_2", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[1]"))
defineProperty("sim_rud_3", globalPropertyf("sim/flightmodel/engine/ENGN_thro_use[2]"))

defineProperty("revers_flap_L", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[0]")) 
defineProperty("revers_flap_R", globalPropertyf("sim/flightmodel2/engines/thrust_reverser_deploy_ratio[2]")) 

defineProperty("eng_modL", globalPropertyf("sim/flightmodel/engine/ENGN_propmode[0]")) 
defineProperty("eng_modR", globalPropertyf("sim/flightmodel/engine/ENGN_propmode[2]")) 

defineProperty("anim_rud1", globalPropertyf("sim/custom/controlls/throttle_1")) 
defineProperty("anim_rud2", globalPropertyf("sim/custom/controlls/throttle_2")) 
defineProperty("anim_rud3", globalPropertyf("sim/custom/controlls/throttle_3")) 

defineProperty("anim_rud1_ENG", globalPropertyf("sim/custom/controlls/throttle_1_ENG")) 
defineProperty("anim_rud2_ENG", globalPropertyf("sim/custom/controlls/throttle_2_ENG")) 
defineProperty("anim_rud3_ENG", globalPropertyf("sim/custom/controlls/throttle_3_ENG")) 

defineProperty("revers_L", globalPropertyf("sim/custom/controlls/revers_L")) 
defineProperty("revers_R", globalPropertyf("sim/custom/controlls/revers_R")) 

defineProperty("throttle_lock", globalPropertyf("sim/custom/controlls/throttle_lock")) 

defineProperty("msl_alt", globalPropertyf("sim/flightmodel/position/elevation"))  

-- ИЗМЕНЕНО для XP12: старый sim/weather/barometer_sealevel_inhg (REPLACED) заменён
-- на новый sim/weather/region/sealevel_pressure_pas (в паскалях).
-- Конвертация: 1 inHg = 3386.389 Pa, поэтому в коде ниже добавлен пересчёт в inHg.
defineProperty("baro_press_pas", globalPropertyf("sim/weather/region/sealevel_pressure_pas"))  

defineProperty("rud_1_spd", globalPropertyf("sim/custom/absu/rud_1_spd")) 
defineProperty("rud_2_spd", globalPropertyf("sim/custom/absu/rud_2_spd")) 
defineProperty("rud_3_spd", globalPropertyf("sim/custom/absu/rud_3_spd")) 

-- failures
defineProperty("comsta0", globalPropertyi("sim/operation/failures/rel_comsta0")) 
defineProperty("comsta1", globalPropertyi("sim/operation/failures/rel_comsta1"))
defineProperty("comsta2", globalPropertyi("sim/operation/failures/rel_comsta2"))

-- time
defineProperty("frame_time", globalPropertyf("sim/custom/time/frame_time")) 
defineProperty("outside_air_temp", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc")) 

defineProperty("rev_fail", globalPropertyi("sim/operation/failures/rel_revloc1")) 
defineProperty("rev_fail_2", globalPropertyi("sim/operation/failures/rel_revers1")) 
defineProperty("override", globalPropertyi("sim/operation/override/override_throttles"))

-- engine result power
defineProperty("acf_tmax", globalPropertyf("sim/aircraft/engine/acf_tmax")) 
defineProperty("throttle_ratio_all", globalPropertyf("sim/cockpit2/engine/actuators/throttle_ratio_all")) 

-- Smart Copilot
defineProperty("ismaster", globalPropertyf("scp/api/ismaster")) 
defineProperty("hascontrol_1", globalPropertyf("scp/api/hascontrol_1")) 

set(override, 1) 

local xp_ver = get(xp_version)
local IS_XP12 = xp_ver >= 120000
local XP11 = xp_ver >= 110000 and xp_ver < 120000  -- только XP11, не XP12

if XP11 then
	set(sim_rud_1, 0.45)
	set(sim_rud_2, 0.45)
	set(sim_rud_3, 0.45)
else
	-- начальное значение соответствует малому газу (0.42 номин.)
	set(sim_rud_1, 0.38)
	set(sim_rud_2, 0.38)
	set(sim_rud_3, 0.38)
end

-- reference tables
-- forward_table: позиция РУД (0-1) → тяга (0-1)
-- По РЛЭ Таблица 8.1.1 (наземные режимы МСА):
--   Малый газ:            КВД 59.5-61.5%  → joy=0.0  → 0.38 (0,42 номин.)
--   0,6 номинального:     КВД 85.5-88.0%  → joy=0.5  → 0.55
--   0,7 номинального:     КВД 87.5-90.0%  → joy=0.6  → 0.65
--   Номинальный:          КВД 93.0-95.0%  → joy=0.7  → 0.805
--   Взлётный:             КВД 94.5-96.0%  → joy=1.0  → 0.975
local forward_table = {
    { -10000, 0.00  },
    {   0.0,  0.15  },  -- малый газ: 0,42 номин. (КВД 59.5-61.5% по РЛЭ) 
    {   0.5,  0.55  },  -- 0,6 номин.
    {   0.6,  0.637 },  -- между 0,6 и 0,7 номин.
    {   0.65, 0.72  },  -- 0,7 номин.
    {   0.7,  0.805 },  -- номинальный
    {   0.8,  0.886 },
    {   1.0,  0.975 },  -- взлётный
    {   1.1,  1.0   },
    {   1.2,  1.2   },
    { 100000, 1.3   }
}
local reverse_table = {{ -10000, 0.04 }, { 0.0, 0.18 }, { 0.5, 0.18 }, { 0.6, 0.8}, { 1.0, 0.8 }, { 100000, 0.8 }}
local rud_T_tbl = {{ -10000, 10 }, { -60, 10 }, { 0, 1}, { 40, 0.4}, { 60, 0.3}, { 100000, 0.1 }}

local thro_1_pos, thro_2_pos, thro_3_pos = 0, 0, 0
local thro_1_pos_ENG, thro_3_pos_ENG = 0, 0
local rev_L_pos, rev_R_pos = 0, 0

local joy_pos_last_1 = get(tro_comm_1)
local joy_pos_last_2 = get(tro_comm_2)
local joy_pos_last_3 = get(tro_comm_3)

local virtual_rud_1, virtual_rud_2, virtual_rud_3 = 0.02, 0.02, 0.02
local virtual_rud_1_act, virtual_rud_2_act, virtual_rud_3_act = 0.02, 0.02, 0.02

local joy_rud_pos_1 = get(tro_comm_1)
local joy_rud_pos_2 = get(tro_comm_2)
local joy_rud_pos_3 = get(tro_comm_3)

rev_comm = findCommand("sim/engines/thrust_reverse_toggle")
function rev_comm_hnd(phase)
	if 0 == phase then set(throttle_ratio_all, 0) end
	return 0
end
registerCommandHandler(rev_comm, 0, rev_comm_hnd)

function update()
	local passed = get(frame_time)
	local stop_lever = get(throttle_lock) 
	
	local rev_L = get(eng_modL) == 3
	local rev_R = get(eng_modR) == 3
	
	local joy_rud_MAX_1, joy_rud_MIN_1 = 1, 0.02
	local joy_rud_MAX_2, joy_rud_MIN_2 = 1, 0.02
	local joy_rud_MAX_3, joy_rud_MIN_3 = 1, 0.02

	if XP11 then
		joy_rud_MIN_1, joy_rud_MIN_2, joy_rud_MIN_3 = 0.175, 0.175, 0.175
	end

	-- ИЗМЕНЕНО для XP12: давление теперь приходит в паскалях, конвертируем в inHg
	-- 1 inHg = 3386.389 Pa
	local baro_inhg = get(baro_press_pas) / 3386.389
	-- высота барометрическая в метрах (msl_alt уже в метрах в XP12)
	local alt_baro = get(msl_alt) + (29.92 - baro_inhg) * 304.8

	-- Коэффициент тяги по высоте для Д-30КУ-154
	-- По РЛЭ Таблица 8.1.2 (H=11км M=0.8): взлётный режим КВД 95.5-97.5%
	-- Тяга на 11км составляет примерно 35-40% от земной — XP12 обрабатывает сам
	-- Коэффициент здесь только для масштабирования acf_tmax
	-- XP11: нужна коррекция ~1.07 на крейсере
	-- XP12: физика высотной тяги встроена, достаточно небольшой коррекции ~1.05
	local height_coef = XP11 and line(alt_baro, 0, 1, 11000, 1.07) or line(alt_baro, 0, 1, 11000, 1.05)

	if get(comsta0) == 6 then joy_rud_MAX_1, joy_rud_MIN_1 = 0.05, 0 end
	if get(comsta1) == 6 then joy_rud_MAX_2, joy_rud_MIN_2 = 0.05, 0 end
	if get(comsta2) == 6 then joy_rud_MAX_3, joy_rud_MIN_3 = 0.05, 0 end

	local rud_spd_1, rud_spd_2, rud_spd_3 = get(rud_1_spd), get(rud_2_spd), get(rud_3_spd)
	local joy_pos_1, joy_pos_2, joy_pos_3 = get(tro_comm_1), get(tro_comm_2), get(tro_comm_3)
	
	-- Take controls of RUDs
	if rud_spd_1 ~= 0 then joy_rud_pos_1 = joy_rud_pos_1 + rud_spd_1 * passed
	elseif math.abs(joy_pos_1 - joy_pos_last_1) > 0.001 then joy_rud_pos_1 = joy_pos_1 end
	
	if rud_spd_2 ~= 0 then joy_rud_pos_2 = joy_rud_pos_2 + rud_spd_2 * passed
	elseif math.abs(joy_pos_2 - joy_pos_last_2) > 0.001 then joy_rud_pos_2 = joy_pos_2 end
	
	if rud_spd_3 ~= 0 then joy_rud_pos_3 = joy_rud_pos_3 + rud_spd_3 * passed
	elseif math.abs(joy_pos_3 - joy_pos_last_3) > 0.001 then joy_rud_pos_3 = joy_pos_3 end
	
	if math.abs(joy_pos_last_1 - joy_pos_1) > 0.001 then joy_pos_last_1 = joy_pos_1 end
	if math.abs(joy_pos_last_2 - joy_pos_2) > 0.001 then joy_pos_last_2 = joy_pos_2 end
	if math.abs(joy_pos_last_3 - joy_pos_3) > 0.001 then joy_pos_last_3 = joy_pos_3 end

	joy_rud_pos_1 = math.max(0, math.min(1, joy_rud_pos_1))
	joy_rud_pos_2 = math.max(0, math.min(1, joy_rud_pos_2))
	joy_rud_pos_3 = math.max(0, math.min(1, joy_rud_pos_3))
	
	if stop_lever < 0.2 then
		-- Engine 1 logic
		if rev_L then
			thro_1_pos = 0
			thro_1_pos_ENG = -interpolate(reverse_table, joy_rud_pos_1) * 0.4
			rev_L_pos = -thro_1_pos_ENG * 2.5
			virtual_rud_1 = joy_rud_MIN_1 + (joy_rud_MAX_1 - joy_rud_MIN_1) * interpolate(reverse_table, joy_rud_pos_1)
		else
			thro_1_pos, thro_1_pos_ENG, rev_L_pos = joy_rud_pos_1, joy_rud_pos_1, 0
			virtual_rud_1 = joy_rud_MIN_1 + (joy_rud_MAX_1 - joy_rud_MIN_1) * interpolate(forward_table, joy_rud_pos_1)
		end

		-- Engine 2 logic
		-- По РЛЭ Ту-154М: двигатель №2 (хвостовой, центральный) РЕВЕРСА НЕ ИМЕЕТ
		-- При включении реверса двигателей №1 и №3 — двигатель №2 переводится на малый газ
		if rev_L or rev_R then
			thro_2_pos = 0
			-- малый газ для двигателя №2 при реверсе остальных
			virtual_rud_2 = joy_rud_MIN_2 + (joy_rud_MAX_2 - joy_rud_MIN_2) * interpolate(forward_table, joy_rud_MIN_2)
		else
			thro_2_pos = joy_rud_pos_2
			virtual_rud_2 = joy_rud_MIN_2 + (joy_rud_MAX_2 - joy_rud_MIN_2) * interpolate(forward_table, joy_rud_pos_2)
		end

		-- Engine 3 logic
		if rev_R then
			thro_3_pos = 0
			thro_3_pos_ENG = -interpolate(reverse_table, joy_rud_pos_3) * 0.4
			rev_R_pos = -thro_3_pos_ENG * 2.5
			virtual_rud_3 = joy_rud_MIN_3 + (joy_rud_MAX_3 - joy_rud_MIN_3) * interpolate(reverse_table, joy_rud_pos_3)
		else
			thro_3_pos, thro_3_pos_ENG, rev_R_pos = joy_rud_pos_3, joy_rud_pos_3, 0
			virtual_rud_3 = joy_rud_MIN_3 + (joy_rud_MAX_3 - joy_rud_MIN_3) * interpolate(forward_table, joy_rud_pos_3)
		end
	end
	
	---------------------------------------------------------
	-- ИЗМЕНЕННЫЙ БЛОК: МГНОВЕННЫЙ ОТКЛИК (БЕЗ ЗАДЕРЖКИ)
	---------------------------------------------------------
	virtual_rud_1_act = virtual_rud_1
	virtual_rud_2_act = virtual_rud_2
	virtual_rud_3_act = virtual_rud_3
	---------------------------------------------------------
	
	local thro_high_1 = line(virtual_rud_1_act, 0, XP11 and 0.525 or 0.35, 1, XP11 and 1.07 or 1.1)
	local thro_high_2 = line(virtual_rud_2_act, 0, XP11 and 0.525 or 0.35, 1, XP11 and 1.07 or 1.1)
	local thro_high_3 = line(virtual_rud_3_act, 0, XP11 and 0.525 or 0.35, 1, XP11 and 1.07 or 1.1)
	
	local thro_1 = line(alt_baro, 0, virtual_rud_1_act, 11000, thro_high_1)
	local thro_2 = line(alt_baro, 0, virtual_rud_2_act, 11000, thro_high_2)
	local thro_3 = line(alt_baro, 0, virtual_rud_3_act, 11000, thro_high_3)
	
	local MASTER = get(ismaster) ~= 1	

	if MASTER then	
		set(anim_rud1, thro_1_pos)
		set(anim_rud2, thro_2_pos)
		set(anim_rud3, thro_3_pos)

		set(anim_rud1_ENG, thro_1_pos_ENG)
		set(anim_rud2_ENG, thro_2_pos)
		set(anim_rud3_ENG, thro_3_pos_ENG)
		
		set(throttle_lock, stop_lever)
		set(revers_L, rev_L_pos)
		set(revers_R, rev_R_pos)
		
		set(sim_rud_1, thro_1)
		set(sim_rud_2, thro_2)
		set(sim_rud_3, thro_3)
	end
	
	set(rev_fail, 6) 
	set(rev_fail_2, 6)
	-- Д-30КУ-154: взлётная тяга 10800 кгс = 105948 Н (по паспорту двигателя)
	-- Небольшая поправка +2% для компенсации потерь в модели XP12
	set(acf_tmax, 105948 * 1.02 * height_coef)  -- ~108067 Н с поправкой
end

function onAvionicsDone()
	set(override, 0)
	print("throttles released")
end
