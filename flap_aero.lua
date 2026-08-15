-- ================================================================= --
-- Аэродинамика механизации Ту-154М: Закрылки, Предкрылки и Посадка
-- ПОЛНОСТЬЮ ИСПРАВЛЕННАЯ ВЕРСИЯ (Фикс ошибок globalPropertyf)
-- Оптимизировано под режим 78-80% PRM и мягкое касание
-- ================================================================= --

-- Основные коэффициенты (DataRefs) - Везде используем globalPropertyf
defineProperty("cl", globalPropertyf("sim/aircraft/controls/acf_flap_cl"))
defineProperty("cd", globalPropertyf("sim/aircraft/controls/acf_flap_cd"))
defineProperty("cm", globalPropertyf("sim/aircraft/controls/acf_flap_cm"))

defineProperty("cl2", globalPropertyf("sim/aircraft/controls/acf_flap2_cl"))
defineProperty("cd2", globalPropertyf("sim/aircraft/controls/acf_flap2_cd"))
defineProperty("cm2", globalPropertyf("sim/aircraft/controls/acf_flap2_cm"))

-- Положения механизации
defineProperty("flap_inn_L", globalPropertyf("sim/flightmodel/controls/wing1l_fla1def")) 
defineProperty("flap_mid_L", globalPropertyf("sim/flightmodel/controls/wing2l_fla2def")) 
defineProperty("slat_L", globalPropertyf("sim/flightmodel/controls/wing1l_sla1def")) -- Предкрылки

-- Параметры двигателей и атмосферы (Исправлено на globalPropertyf)
defineProperty("thrust_L", globalPropertyf("sim/cockpit2/engine/indicators/thrust_n[0]")) 
defineProperty("thrust_R", globalPropertyf("sim/cockpit2/engine/indicators/thrust_n[2]"))
defineProperty("true_airspeed", globalPropertyf("sim/flightmodel/position/true_airspeed"))
defineProperty("dens", globalPropertyf("sim/weather/rho"))

-- Экран и Шасси (Исправлено на globalPropertyf)
defineProperty("cl_GE1", globalPropertyf("sim/flightmodel/parts/CL_grndeffect[8]"))
defineProperty("gear_on_ground_L", globalPropertyf("sim/flightmodel2/gear/on_ground[1]")) 
defineProperty("gear_on_ground_R", globalPropertyf("sim/flightmodel2/gear/on_ground[2]")) 

-- Силы и моменты (Исправлено на globalPropertyf)
defineProperty("pitch_add", globalPropertyf("sim/flightmodel/forces/M_plug_acf"))
defineProperty("lift_left", globalPropertyf("sim/flightmodel2/wing/elements/element_cl_total[2]"))
defineProperty("lift_right", globalPropertyf("sim/flightmodel2/wing/elements/element_cl_total[12]"))

-- Таблицы интерполяции
local engine_lift_tbl = { {-300, 1}, {300, 1}, {420, 0}, {1000, 0} }
local engine_lift_tbl2 = { {0, 0}, {5500, 1}, {100000, 1} }

function update()
    -- Получение данных
    local t_L = get(thrust_L)
    local t_R = get(thrust_R)
    local tas = get(true_airspeed) * 3.6
    local q = get(dens) / 2 * math.pow(tas / 3.6, 2)
    
    local f_inn = math.max(get(flap_inn_L), 15)
    local f_out = math.max(get(flap_mid_L), 15)
    local slat = get(slat_L)
    
    -- Состояние касания
    local main_on_ground = (get(gear_on_ground_L) + get(gear_on_ground_R)) > 0.5

    -- 1. Влияние предкрылков
    local slat_cl_add = slat * 0.0016 
    local slat_cm_add = slat * 0.0024 
    local slat_cd_add = slat * 0.0007 

    -- 2. Ground Effect (Экран)
    local GE_val = get(cl_GE1)
    if GE_val < 1.0 then GE_val = 1.0 end
    if GE_val > 1.12 then GE_val = 1.12 end

    -- 3. Коэффициент момента (CM) - Квадратичные функции под 36 градусов
    local flap1_cm = (-1.15e-04 * math.pow(f_inn, 2) + 2.20e-04 * f_inn - 0.38) + slat_cm_add
    local flap2_cm = (-2.30e-04 * math.pow(f_out, 2) + 3.10e-04 * f_out - 0.28) + (slat_cm_add * 0.5)
    
    -- Коррекция у земли (облегчение носа для посадки на основные стойки)
    local cm_corr = (0.43 * math.pow(GE_val, 2) - 0.12 * GE_val - 0.26) / (GE_val - 0.93)
    if main_on_ground then cm_corr = cm_corr * 0.5 end -- Смягчение кивка при касании

    flap1_cm = flap1_cm * cm_corr
    flap2_cm = flap2_cm * cm_corr

    -- 4. Коэффициент сопротивления (CD) - Настройка под 78-80% PRM
    local flap1_cd = (2.80e-05 * math.pow(f_inn, 2) + 3.75e-03 * f_inn + 0.058) + slat_cd_add
    local flap2_cd = (3.15e-05 * math.pow(f_out, 2) + 3.95e-03 * f_out + 0.063) + slat_cd_add
    
    local cd_corr = 0.00115 * math.pow(GE_val, 33.0) + 0.99
    local final_cd1 = flap1_cd * cd_corr * 0.93 -- "Чистая" аэродинамика М-ки
    local final_cd2 = flap2_cd * cd_corr * 0.93

    -- 5. Коэффициент подъемной силы (CL)
    local flap1_cl = (6.00e-04 * math.pow(f_inn, 2) - 1.30e-02 * f_inn + 1.08) + slat_cl_add
    local flap2_cl = (7.85e-04 * math.pow(f_out, 2) - 1.20e-02 * f_out + 1.18) + slat_cl_add

    -- 6. Момент от двигателей
    local spd_f = interpolate(engine_lift_tbl, tas)
    local lift_tot = (get(lift_left) + get(lift_right)) / 2 * q
    local lft_f = interpolate(engine_lift_tbl2, lift_tot)
    
    local eng_m = 80000 * 0.05 * 9.81 * 2.6 * (1.45 * (t_L + t_R) / 100000) * spd_f * lft_f
    
    if tas > 60 then 
        set(pitch_add, eng_m)
    else
        set(pitch_add, 0)
    end

    -- Запись финальных значений
    set(cl, flap1_cl)
    set(cl2, flap2_cl)
    set(cd, final_cd1)
    set(cd2, final_cd2)
    set(cm, flap1_cm)
    set(cm2, flap2_cm)
end
