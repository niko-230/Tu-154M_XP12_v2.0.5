-- apu_logic.lua — ВСУ ТА-6А для Ту-154М
-- Полная реализация по РЛЭ Ту-154М Подраздел 8.2
-- ============================================================
-- РЛЭ 8.2.1 — Эксплуатационные ограничения ТА-6А:
--   Время выхода на холостой ход (земля): норма 32-37 сек, макс 40 сек
--   Время выхода на холостой ход (полёт): макс 60 сек
--   Обороты холостого хода:               норма 98%, макс 100%
--   Выброс оборотов при запуске:           до 103%, снижение до 99±1 за 3 сек
--   ЭГТ при запуске:                       макс 680°C (авт.останов), не более 700°C
--   ЭГТ режим нагрузки:                    макс 550°C
--   Обороты режим нагрузки (земля):        норма 97-101%, макс 103%
--   Обороты режим нагрузки (>3000м):       макс 103,5%
--   Табло "ВЫХОД НА РЕЖИМ":                загорается при 90%
--   Отбор воздуха разрешён при:            RPM >= 92%
--   Холодная прокрутка:                    19-23%, до 32 сек
--   Выбег 30%→10%:                         14 сек
--   Высота запуска:                        до 3000 м
--   Запуск при t° масла ниже -25°C:        ЗАПРЕЩАЕТСЯ
--   Температура масла в маслобаке:         макс 115°C
--   Прогрев перед нагрузкой:               1 мин на малом газу
-- ============================================================
-- РЛЭ 8.2.1(2) — Попытки запуска:
--   От наземного источника: макс 7 попыток
--     перерыв между 1-5 попытками: мин 1 мин
--     перерыв после 5-й попытки:   мин 15 мин
--     перерыв после 6-й попытки:   мин 1 мин
--     после 7-й: охлаждение стартера не менее 2 часов
--   От аккумуляторов: макс 3 попытки, перерыв 3 мин
-- ============================================================

-- controls
defineProperty("apu_main_switch", globalPropertyi("sim/custom/switchers/eng/apu_main_switch"))
defineProperty("apu_start_mode",  globalPropertyi("sim/custom/switchers/eng/apu_start_mode"))
defineProperty("apu_air_bleed",   globalPropertyi("sim/custom/switchers/eng/apu_air_bleed"))
defineProperty("apu_start",       globalPropertyi("sim/custom/buttons/eng/apu_start"))
defineProperty("apu_stop",        globalPropertyi("sim/custom/buttons/eng/apu_stop"))

-- internal DataRefs
defineProperty("apu_n1",     globalPropertyf("sim/custom/eng/apu_n1"))
defineProperty("apu_oil_t",  globalPropertyf("sim/custom/eng/apu_oil_t"))
defineProperty("apu_oil_q",  globalPropertyf("sim/custom/eng/apu_oil_q"))
defineProperty("apu_oil_p",  globalPropertyf("sim/custom/eng/apu_oil_p"))
defineProperty("apu_egt",    globalPropertyf("sim/custom/eng/apu_egt"))

defineProperty("bus27_volt_left",  globalPropertyf("sim/custom/elec/bus27_volt_left"))
defineProperty("bus27_volt_right", globalPropertyf("sim/custom/elec/bus27_volt_right"))
defineProperty("gen4_amp_bus",     globalPropertyf("sim/custom/elec/gen4_amp"))

defineProperty("apu_system_on",  globalPropertyi("sim/custom/eng/apu_system_on"))
defineProperty("apu_fuel_last",  globalPropertyf("sim/custom/eng/apu_fuel_last"))
defineProperty("tank1_w",        globalPropertyf("sim/flightmodel/weight/m_fuel[0]"))

-- results
defineProperty("apu_air_press",    globalPropertyf("sim/custom/eng/apu_air_press"))
defineProperty("apu_air_doors",    globalPropertyf("sim/custom/eng/apu_air_doors"))
defineProperty("apu_fuel_p",       globalPropertyf("sim/custom/eng/apu_fuel_p"))
defineProperty("apu_start_bus",    globalPropertyf("sim/custom/elec/apu_start_bus"))
defineProperty("apu_start_cc",     globalPropertyf("sim/custom/elec/apu_start_cc"))
defineProperty("apu_start_seq",    globalPropertyi("sim/custom/elec/apu_start_seq"))
defineProperty("fuel_pumps_27_cc", globalPropertyf("sim/custom/elec/fuel_pumps_27_cc"))
defineProperty("apu_doors",        globalPropertyf("sim/custom/anim/apu_doors"))
defineProperty("apu_burn_fuel",    globalPropertyi("sim/custom/elec/apu_burning_fuel"))
-- прогрев: флаг готовности к подключению нагрузки (1 = прогрет)
defineProperty("apu_ready",        globalPropertyi("sim/custom/eng/apu_ready"))
-- фаза запуска для индикации (0=нет, 1=стартер, 2=горение, 3=выброс, 4=режим)
defineProperty("apu_start_phase",  globalPropertyi("sim/custom/eng/apu_start_phase"))
-- таймер перерыва (для отображения экипажу)
defineProperty("apu_cooldown",     globalPropertyf("sim/custom/eng/apu_cooldown"))

-- sim APU datarefs — для поддержания давления воздуха отбора
-- XP12 поддерживает давление сам когда bleed_air_mode=4 и APU запущен
defineProperty("APU_generator_on",  globalPropertyi("sim/cockpit2/electrical/APU_generator_on"))
defineProperty("APU_starter_switch",globalPropertyi("sim/cockpit2/electrical/APU_starter_switch"))
defineProperty("APU_N1_percent",    globalPropertyi("sim/cockpit2/electrical/APU_N1_percent"))
defineProperty("APU_running",       globalPropertyi("sim/cockpit2/electrical/APU_running"))
defineProperty("acf_has_APU_switch",globalPropertyi("sim/aircraft/overflow/acf_has_APU_switch"))
defineProperty("rel_APU_press",     globalPropertyi("sim/operation/failures/rel_APU_press"))
defineProperty("bleed_air_mode",    globalPropertyi("sim/cockpit2/pressurization/actuators/bleed_air_mode"))
defineProperty("rpm_high_2",     globalPropertyf("sim/custom/gauges/engine/rpm_high_2"))
defineProperty("eng_airvalve_2", globalPropertyi("sim/custom/bleed/eng_airvalve_2"))

-- time / sim
defineProperty("frame_time",       globalPropertyf("sim/custom/time/frame_time"))
defineProperty("outside_air_temp", globalPropertyf("sim/cockpit2/temperature/outside_air_temp_degc"))
defineProperty("msl_alt",          globalPropertyf("sim/flightmodel/position/elevation"))
defineProperty("baro_press",       globalPropertyf("sim/weather/region/sealevel_pressure_pas"))

-- Smart Copilot
defineProperty("ismaster",     globalPropertyf("scp/api/ismaster"))
defineProperty("hascontrol_1", globalPropertyf("scp/api/hascontrol_1"))

-- failures
defineProperty("apu_start_fail",     globalPropertyi("sim/custom/failures/apu_start_fail"))
defineProperty("apu_gen_fail",       globalPropertyi("sim/custom/failures/apu_gen_fail"))
defineProperty("apu_runtime",        globalPropertyf("sim/custom/failures/apu_runtime"))
defineProperty("apu_fail_oilt",      globalPropertyi("sim/custom/failures/apu_fail_oilt"))
defineProperty("apu_fail_egt",       globalPropertyi("sim/custom/failures/apu_fail_egt"))
defineProperty("apu_fail_fuel_left", globalPropertyi("sim/custom/failures/apu_fail_fuel_left"))
defineProperty("apu_fail",           globalPropertyi("sim/custom/failures/apu_fail"))
defineProperty("apu_press_fail",     globalPropertyi("sim/custom/failures/apu_press_fail"))
defineProperty("failures_enabled",   globalPropertyi("sim/custom/failures/failures_enabled"))
defineProperty("apu_apd_working",    globalPropertyi("sim/custom/elec/apu_apd_working"))
defineProperty("apd_working_1",      globalPropertyf("sim/custom/start/apd_working_1"))
defineProperty("apd_working_2",      globalPropertyf("sim/custom/start/apd_working_2"))
defineProperty("apd_working_3",      globalPropertyf("sim/custom/start/apd_working_3"))
defineProperty("eng4_ext",           globalPropertyi("sim/custom/fire/apu_ext_used"))

set(apu_runtime, math.random(280, 320) * 3600)

-- инициализация датарефа масла при загрузке скрипта
-- без этого oil_q = 0 при старте симулятора → давление = 0 → лампа горит
if get(apu_oil_q) <= 0 then
    set(apu_oil_q, 1.0)
end

-- ============================================================
-- КОНСТАНТЫ по РЛЭ 8.2.1
-- ============================================================
local RPM_COLD_MAX   = 23    -- максимум холодной прокрутки %
local RPM_IGNITE     = 18    -- минимум RPM для воспламенения
local RPM_MODE_LAMP  = 90    -- табло ВЫХОД НА РЕЖИМ
local RPM_BLEED      = 92    -- разрешение отбора воздуха
local RPM_IDLE_NOM   = 98    -- номинальные обороты ХХ
local RPM_IDLE_MAX   = 100   -- максимум ХХ
local RPM_LOAD_MAX   = 103   -- максимум под нагрузкой
local EGT_START_MAX  = 680   -- авт.останов при запуске
local EGT_LOAD_MAX   = 550   -- макс при нагрузке
local EGT_LOAD_STOP  = 570   -- авт.останов при нагрузке
local TIME_START_GND = 40    -- макс время запуска земля
local TIME_START_AIR = 60    -- макс время запуска воздух
local TIME_WARMUP    = 60    -- прогрев перед нагрузкой (сек)
local OIL_T_MIN      = -25   -- минимум t° масла для запуска
local OIL_T_MAX      = 115   -- максимум t° масла
local ALT_MAX        = 3000  -- максимальная высота запуска м

-- ============================================================
-- СОСТОЯНИЕ
-- ============================================================
local RPM             = 0
local oil_q           = 1
local apu_doors_pos   = get(apu_doors)
local bleed_doors_pos = get(apu_air_doors)
local burning         = 0
local starter_on      = 0
local fuel_last       = get(apu_fuel_last)
local egt             = get(outside_air_temp)
local apu_temp        = get(outside_air_temp)
local oil_temp        = get(outside_air_temp)
local eng2_corr       = 0
local oil_overheat_t  = 0
local minus_timer     = 0
local false_bleed     = 0
local emerg_off       = 0

-- ============================================================
-- МАШИНА СОСТОЯНИЙ ЗАПУСКА
-- ============================================================
-- Фазы:
--  0 = ВСУ не активна
--  1 = ХОЛОДНАЯ ПРОКРУТКА (mode_sw=2): стартер без топлива, 19-23%
--  2 = СТАРТЕР: раскрутка 0→18% (до воспламенения)
--  3 = ВОСПЛАМЕНЕНИЕ: рост 18→90%
--  4 = ВЫБРОС: 90→103% и гашение
--  5 = ПРОГРЕВ: RPM ~98%, ждём 60 сек перед нагрузкой (РЛЭ)
--  6 = РЕЖИМ: ВСУ готова к нагрузке
local phase          = 0
local start_timer    = 0    -- время в текущей фазе
local total_timer    = 0    -- общее время с нажатия ЗАПУСК
local overshoot_rpm  = 101  -- целевой выброс оборотов
local warmup_timer   = 0    -- таймер прогрева (60 сек)
local apu_is_ready   = 0    -- 1 = прогрет, готов к нагрузке

-- ============================================================
-- СЧЁТЧИК ПОПЫТОК (РЛЭ 8.2.1(2))
-- ============================================================
local attempt_count    = 0
local cooldown_timer   = 0
local cooldown_req     = 0
local start_blocked    = false
local starter_hot_lock = false

-- ============================================================
-- ТАБЛИЦЫ ФИЗИКИ
-- ============================================================

-- торможение / выбег (выбег 30%→10% = 14 сек по РЛЭ)
local off_tbl = {
    { -500,  30   },
    {    0,   0   },
    {    3,  -2   },
    {    5,  -0.1 },
    {   10,  -0.15},
    {   20,  -0.8 },
    {   30,  -2.0 },
    {   40,  -3.5 },
    {   55,  -5.0 },
    {   60, -15.0 },
    {  100, -15.0 },
    { 1000,-100.0 },
}

-- стартер: раскручивает 0→21% за 8-10 сек
local starter_tbl = {
    { -500, 20   },
    {    0, 10   },
    {    3,  8   },
    {   15,  4   },
    {   20,  5   },
    {   23,  2.5 },
    {   30,  0   },
    { 1000,  0   },
}

-- горение топлива: откалибровано под 32-37 сек выхода на режим
local fuel_tbl = {
    { -500,  0   },
    {    0,  0   },
    {   18,  0   },
    {   20,  1.5 },
    {   25,  4.0 },
    {   30,  6.0 },
    {   35,  8.0 },
    {   45, 12.0 },
    {   60, 20.0 },
    {   75, 24.0 },
    {   85, 26.0 },
    {   90, 30.0 },
    {   94, 20.0 },  -- замедление после выброса
    {   96, 16.0 },
    {   98, 15.5 },  -- равновесие: +15.5 -15.0 = +0.5 → стабилизация 98-100%
    {  100, 14.5 },  -- небольшой перевес → не падает ниже 98%
    {  101, 10.0 },
    {  103, -8.0 },  -- гашение выброса
    {  106,-20.0 },
    { 1000,-20.0 },
}

-- коэффициент от температуры масла
local oil_tbl = {
    { -500,  10  },
    {  -30,   1.2},
    {    0,   1.1},
    {   30,   1.0},
    {  150,   0.9},
    { 1000,   0.7},
}

-- ============================================================
-- ВСПОМОГАТЕЛЬНАЯ ФУНКЦИЯ: запуск таймера перерыва
-- ============================================================
local function start_cooldown(ground)
    attempt_count = attempt_count + 1
    if ground then
        if attempt_count >= 7 then
            starter_hot_lock = true
            cooldown_req     = 7200   -- 2 часа охлаждения стартера
        elseif attempt_count == 5 then
            cooldown_req = 900        -- 15 мин после 5-й
        elseif attempt_count == 6 then
            cooldown_req = 60         -- 1 мин после 6-й
        else
            cooldown_req = 60         -- 1 мин между 1-5 попытками
        end
    else
        if attempt_count >= 3 then
            starter_hot_lock = true
            cooldown_req     = 7200
        else
            cooldown_req = 180        -- 3 мин от аккумуляторов
        end
    end
    cooldown_timer = cooldown_req
    start_blocked  = (cooldown_req > 0)
end

-- ============================================================
-- ФУНКЦИЯ ОБНОВЛЕНИЯ
-- ============================================================
function update()
    local passed = get(frame_time)
    if passed <= 0 or passed > 0.5 then return end

    RPM            = get(apu_n1)
    oil_q          = math.max(0.01, get(apu_oil_q))  -- защита от неинициализированного датарефа
    oil_temp       = get(apu_oil_t)
    apu_doors_pos  = get(apu_doors)
    bleed_doors_pos= get(apu_air_doors)
    burning        = get(apu_burn_fuel)
    egt            = get(apu_egt)

    local MASTER = get(ismaster) ~= 1
    if not MASTER then return end

    local fail_fuel  = get(apu_fail_fuel_left)
    local fail_egt   = get(apu_fail_egt)
    local fail_oilt  = get(apu_fail_oilt)
    local fail_gen   = get(apu_fail)
    local fail_start = get(apu_start_fail)

    local mode_sw    = get(apu_start_mode)
    local main_sw    = get(apu_main_switch)
    local power      = get(apu_start_bus)
    local bus_L      = get(bus27_volt_left)
    local bus_R      = get(bus27_volt_right)
    local out_temp   = get(outside_air_temp)

    local system_on  = (bus_R > 13 and main_sw == 1) and 1 or 0
    local has_fuel   = get(tank1_w) > 150 and 1 or 0
    local ground_pwr = bus_L > 25 or bus_R > 25

    -- -------------------------------------------------------
    -- ТАЙМЕР ПЕРЕРЫВА МЕЖДУ ЗАПУСКАМИ
    -- -------------------------------------------------------
    if cooldown_timer > 0 then
        cooldown_timer = cooldown_timer - passed
        if cooldown_timer <= 0 then
            cooldown_timer = 0
            if not starter_hot_lock then
                start_blocked = false
            end
        end
    end

    -- разблокировка горячего стартера после охлаждения
    if starter_hot_lock and math.abs(apu_temp - out_temp) < 15 and RPM < 1 then
        starter_hot_lock = false
        start_blocked    = false
        cooldown_timer   = 0
        attempt_count    = 0
    end

    -- -------------------------------------------------------
    -- СТВОРКИ ВСУ (внешние)
    -- -------------------------------------------------------
    apu_doors_pos = apu_doors_pos + bus_L * (system_on * 2 - 1) * passed / 81
    apu_doors_pos = math.max(0, math.min(1, apu_doors_pos))

    -- -------------------------------------------------------
    -- СТВОРКИ ОТБОРА ВОЗДУХА
    -- по РЛЭ: отбор воздуха разрешён при RPM >= 92%
    -- тумблер: +1=открыть, 0=нейтраль, -1=закрыть (как в оригинальном скрипте)
    if bus_R > 13 and RPM >= RPM_BLEED and get(apu_press_fail) == 0 then
        bleed_doors_pos = bleed_doors_pos + get(apu_air_bleed) * passed * 0.2
    elseif bus_R > 13 then
        -- RPM < 92% — принудительно закрываем
        bleed_doors_pos = bleed_doors_pos - passed * 0.2
    end
    bleed_doors_pos = math.max(0, math.min(1, bleed_doors_pos))

    -- ДАВЛЕНИЕ ВОЗДУХА для запуска двигателей
    -- нарастает когда створки открыты и ВСУ на режиме
    local air_press = get(apu_air_press)
    if bleed_doors_pos > 0.5 and RPM >= RPM_BLEED then
        air_press = math.min(3.8, air_press + passed * 1.5)
    else
        air_press = math.max(0, air_press - passed * 2.0)
    end
    set(apu_air_press, air_press)

    -- -------------------------------------------------------
    -- ДАВЛЕНИЕ ТОПЛИВА
    -- -------------------------------------------------------
    local fuel_press  = get(apu_fuel_p)
    local fuel_current= 0
    -- топливо подаётся когда переключатель ЗАПУСК=1 или запуск активен
    if (mode_sw == 1 or phase >= 2) and system_on == 1 and power > 13 and has_fuel == 1 then
        fuel_press   = math.min(1, fuel_press + passed * 2)
        fuel_current = 15
    else
        fuel_press   = math.max(0, fuel_press - passed * 2)
        fuel_current = 0
    end

    -- -------------------------------------------------------
    -- МАШИНА СОСТОЯНИЙ
    -- -------------------------------------------------------

    -- *** ФАЗА 0: ВСУ не активна ***
    if phase == 0 then
        starter_on = 0
        burning    = 0

        -- КНОПКА ЗАПУСК (переключатель в положении ЗАПУСК = mode_sw=1)
        if power > 13 and system_on == 1 and get(apu_start) == 1
            and apu_doors_pos > 0.9 and oil_temp >= OIL_T_MIN
            and not start_blocked and not starter_hot_lock
            and mode_sw == 1 then
            phase         = 2
            start_timer   = 0
            total_timer   = 0
            overshoot_rpm = 99 + math.random() * 4
            emerg_off     = 0
            apu_is_ready  = 0
            warmup_timer  = 0
        end

        -- ХОЛОДНАЯ ПРОКРУТКА (переключатель ХОЛ.ПРОКР = mode_sw=2)
        -- по РЛЭ 8.2.1(5): обороты 19-23%, время до 32 сек, без топлива
        if power > 13 and system_on == 1 and get(apu_start) == 1
            and apu_doors_pos > 0.9 and mode_sw == 2
            and not start_blocked and not starter_hot_lock then
            phase       = 1
            start_timer = 0
        end

    -- *** ФАЗА 1: ХОЛОДНАЯ ПРОКРУТКА ***
    elseif phase == 1 then
        starter_on = 1
        burning    = 0

        start_timer = start_timer + passed

        -- ограничение по оборотам (РЛЭ: 19-23%)
        -- off_tbl при 23% даст торможение — стартер удержит в диапазоне

        -- останов по времени (макс 32 сек по РЛЭ) или кнопка СТОП
        if start_timer >= 32 or get(apu_stop) == 1 or power < 5 then
            phase      = 0
            starter_on = 0
            start_cooldown(ground_pwr)
        end

    -- *** ФАЗА 2: РАСКРУТКА СТАРТЕРОМ (0→18%) ***
    elseif phase == 2 then
        starter_on = (fail_start == 0 and fail_gen == 0) and 1 or 0
        burning    = 0

        start_timer  = start_timer  + passed
        total_timer  = total_timer  + passed

        -- переход к воспламенению при RPM > 18%
        if RPM >= RPM_IGNITE and fuel_press > 0.3
            and fail_fuel == 0 and fail_egt == 0 then
            phase       = 3
            start_timer = 0
            burning     = 1
        end

        -- аварийный останов: не воспламенился за 32 сек (стартер отработал)
        if start_timer >= 32 then
            phase      = 0
            starter_on = 0
            burning    = 0
            start_cooldown(ground_pwr)
        end

    -- *** ФАЗА 3: ГОРЕНИЕ + РАСКРУТКА (18→90%) ***
    elseif phase == 3 then
        -- стартер работает пока RPM < 45% или < 32 сек с начала запуска
        starter_on = (total_timer < 32 and RPM < 45
                      and fail_start == 0 and fail_gen == 0) and 1 or 0
        burning    = (fail_fuel == 0 and fail_egt == 0 and fail_gen == 0) and 1 or 0

        start_timer = start_timer + passed
        total_timer = total_timer + passed

        -- переход к выбросу при RPM >= 90%
        if RPM >= RPM_MODE_LAMP then
            phase       = 4
            start_timer = 0
        end

        -- контроль времени: не вышли на режим за TIME_START_GND/AIR сек
        local time_limit = get(msl_alt) > 100 and TIME_START_AIR or TIME_START_GND
        if total_timer > time_limit then
            -- по РЛЭ 8.2.3(I): нажать СТОП при невыходе на режим
            phase      = 0
            starter_on = 0
            burning    = 0
            start_cooldown(ground_pwr)
        end

    -- *** ФАЗА 4: ВЫБРОС ОБОРОТОВ (90→103% и гашение к 98%) ***
    elseif phase == 4 then
        starter_on = 0
        burning    = (fail_fuel == 0 and fail_egt == 0 and fail_gen == 0) and 1 or 0

        start_timer = start_timer + passed

        -- выброс достиг цели — переходим к прогреву
        -- или если через 10 сек не достигли выброса — всё равно идём дальше
        if RPM >= overshoot_rpm or start_timer > 10 then
            phase       = 5
            start_timer = 0
            warmup_timer= 0
        end

    -- *** ФАЗА 5: ПРОГРЕВ (1 мин на малом газу по РЛЭ) ***
    elseif phase == 5 then
        starter_on   = 0
        burning      = (fail_fuel == 0 and fail_egt == 0 and fail_gen == 0) and 1 or 0
        warmup_timer = warmup_timer + passed

        -- прогрев завершён → ВСУ готова к нагрузке
        if warmup_timer >= TIME_WARMUP then
            phase        = 6
            apu_is_ready = 1
        end

        -- ПРИМЕЧАНИЕ РЛЭ: в сложной или аварийной ситуации
        -- разрешается включить нагрузку сразу после загорания табло ВЫХОД НА РЕЖИМ
        -- (реализовано через apu_panel.lua — экипаж может переопределить)

    -- *** ФАЗА 6: РЕЖИМ — ВСУ ГОТОВА К НАГРУЗКЕ ***
    elseif phase == 6 then
        starter_on   = 0
        burning      = (fail_fuel == 0 and fail_egt == 0 and fail_gen == 0) and 1 or 0
        apu_is_ready = 1
    end

    -- -------------------------------------------------------
    -- АВАРИЙНЫЙ ОСТАНОВ (РЛЭ 8.2.3)
    -- -------------------------------------------------------
    -- ЭГТ при запуске > 680°C
    if (phase >= 2 and phase <= 4) and egt > EGT_START_MAX then
        emerg_off = 1
    end
    -- ЭГТ при работе > 570°C
    if (phase == 5 or phase == 6) and egt > EGT_LOAD_STOP then
        emerg_off = 1
    end
    -- обороты > 105%
    if RPM > 105 then emerg_off = 1 end

    if emerg_off == 1 then
        burning    = 0
        starter_on = 0
        if phase >= 2 then
            start_cooldown(ground_pwr)
        end
        phase        = 0
        apu_is_ready = 0
    end

    -- -------------------------------------------------------
    -- КНОПКА СТОП
    -- -------------------------------------------------------
    local eng_starting = get(apd_working_1) + get(apd_working_2) + get(apd_working_3) > 0
    if (get(apu_stop) == 1 and not eng_starting)
        or power < 5
        or get(eng4_ext) == 1 then
        burning    = 0
        starter_on = 0
        if phase >= 2 and phase <= 4 then
            -- неудачная попытка — засчитываем
            start_cooldown(ground_pwr)
        end
        phase        = 0
        apu_is_ready = 0
        emerg_off    = 0
    end

    -- сброс аварийного флага при выключении системы
    if system_on == 0 then emerg_off = 0 end

    -- -------------------------------------------------------
    -- ФИЗИКА ОБОРОТОВ
    -- -------------------------------------------------------
    local t_coef = interpolate(oil_tbl, oil_temp)
    local m_stop = (1 - fail_egt) * (1 - fail_oilt * 0.5)
    local m_fuel = (1 - fail_fuel) * (1 - fail_egt) * (1 - fail_gen)

    RPM = RPM + interpolate(off_tbl,     RPM) * t_coef * m_stop * passed * 0.8
    RPM = RPM + interpolate(starter_tbl, RPM) * starter_on       * passed * 0.8
    RPM = RPM + interpolate(fuel_tbl,    RPM) * burning * m_fuel * (1 - emerg_off) * passed * 0.8

    -- ограничение холодной прокрутки (РЛЭ: 19-23%)
    if phase == 1 and RPM > RPM_COLD_MAX then
        RPM = RPM_COLD_MAX
    end

    -- флаттер от взаимодействия с двигателем №2
    local bleed_flutter = get(eng_airvalve_2) * get(rpm_high_2)
                          * bleed_doors_pos * (math.random(0, 100) - 51) * 0.00004
    false_bleed = false_bleed + (bleed_flutter - false_bleed) * passed * 0.5
    RPM = RPM * (false_bleed + 1)

    if RPM < 0 then RPM = 0 end

    -- ток стартера
    local start_cc = starter_on * 600 / (1 + math.max(RPM - 10, 0) / 5)

    -- -------------------------------------------------------
    -- ЭГТ
    -- -------------------------------------------------------
    local egt_heat = (1000 - egt) * 0.1 * burning
        * (bleed_doors_pos * 0.25 + 1)
        * (get(gen4_amp_bus) * 0.0012 + 1)
    egt_heat = egt_heat - false_bleed * 2000

    local egt_cool = (egt - apu_temp) * (0.5 + ((RPM * 0.01) ^ 1.05) * 1.5) * 0.09

    -- по РЛЭ: при запуске с забросом ЭГТ > 570°C допускается
    -- задержка до 10 сек загорания табло ВЫХОД НА РЕЖИМ
    -- (реализовано через phase — фаза 3 продолжается до 90%)

    if RPM > 5 then
        egt = egt + (egt_heat - egt_cool) * passed
    else
        egt = egt + (out_temp - egt) * passed * 0.001
    end

    -- -------------------------------------------------------
    -- ТЕМПЕРАТУРА КОРПУСА ВСУ
    -- -------------------------------------------------------
    local body_heat = (egt * 0.5 - apu_temp) * 0.005 * (2 - math.abs(RPM) * 0.01)
    local body_cool = (apu_temp - out_temp) * (0.05 + 1.95 * (math.abs(RPM) * 0.01) ^ 0.5) * 0.001
    if RPM > 5 then
        apu_temp = apu_temp + (body_heat - body_cool) * passed / 10
    else
        apu_temp = apu_temp + (out_temp - apu_temp) * passed * 0.0005
    end

    -- корректировка от двигателя №2
    if get(rpm_high_2) > 40 and oil_temp < 46 then
        eng2_corr = eng2_corr + 0.0002 * math.abs(oil_temp) * passed
    elseif eng2_corr > 0 then
        eng2_corr = eng2_corr - 0.0005 * passed
    end

    -- -------------------------------------------------------
    -- ТЕМПЕРАТУРА МАСЛА (макс 115°C по РЛЭ)
    -- -------------------------------------------------------
    local oil_heat = (apu_temp - oil_temp) * 0.55 * (1.2 - oil_q * 0.2) ^ 3
    local oil_cool = (oil_temp - out_temp) * 0.6
    oil_temp = oil_temp + (oil_heat - oil_cool) * passed + eng2_corr

    if oil_temp > OIL_T_MAX then
        oil_q = oil_q - passed * 0.0002
        oil_overheat_t = oil_overheat_t + passed
        if oil_overheat_t > 10 then
            if math.random(math.max(1, 255 - math.floor(oil_temp))) < 5 then
                set(apu_fail_oilt, 1)
            end
            oil_overheat_t = 0
        end
    end

    -- -------------------------------------------------------
    -- ОСТАТОК ТОПЛИВА В КАМЕРЕ
    -- -------------------------------------------------------
    if burning == 1 then fuel_last = 1.2 end
    fuel_last = fuel_last - (math.abs(RPM * 0.01) ^ 0.7) * 0.12 * passed
                          - burning * 0.1 * passed
    if fuel_last < 0 then fuel_last = 0 end

    -- автостоп при высоте > 3000 м (РЛЭ)
    local baro_inhg = get(baro_press) / 3386.389
    local real_alt  = get(msl_alt) + (29.92 - baro_inhg) * 304.8
    if real_alt > ALT_MAX and burning == 1 then
        burning   = 0
        fuel_last = fuel_last + 0.5
        if phase >= 2 then phase = 0; apu_is_ready = 0 end
    end
    set(apu_fuel_last, fuel_last)

    -- -------------------------------------------------------
    -- НАРАБОТКА И ОТКАЗЫ
    -- -------------------------------------------------------
    if get(failures_enabled) > 0 then
        minus_timer = minus_timer + passed * RPM * 0.01
        if minus_timer >= 1 then
            minus_timer = 0
            set(apu_runtime, math.max(0, get(apu_runtime) - 1))
        end
    else
        set(apu_runtime,        300 * 3600)
        set(apu_fail_fuel_left, 0)
        set(apu_fail_egt,       0)
        set(apu_fail_oilt,      0)
        set(apu_start_fail,     0)
    end

    -- -------------------------------------------------------
    -- СИНХРОНИЗАЦИЯ С СИМУЛЯТОРНОЙ ВСУ
    -- XP12 поддерживает давление воздуха отбора сам когда:
    --   bleed_air_mode = 4 (APU) и APU_running = 1
    -- Поэтому синхронизируем состояние нашей ВСУ с симулятором
    -- -------------------------------------------------------
    set(rel_APU_press,      0)          -- отказ давления APU = нет
    set(acf_has_APU_switch, 1)          -- самолёт имеет ВСУ
    set(APU_generator_on,   1)          -- генератор ВСУ включён
    set(bleed_air_mode,     4)          -- режим отбора = APU

    -- синхронизация оборотов и состояния запуска
    set(APU_N1_percent, math.floor(RPM))
    if phase >= 5 and RPM >= 90 then
        -- ВСУ на режиме — симулятор видит её как запущенную
        set(APU_running,        1)
        set(APU_starter_switch, 1)
    elseif phase >= 2 then
        -- идёт запуск
        set(APU_running,        0)
        set(APU_starter_switch, 2)  -- режим запуска
    else
        -- ВСУ остановлена
        set(APU_running,        0)
        set(APU_starter_switch, 0)
    end
    local system_out = (phase > 0 or RPM > 1) and 1 or system_on
    set(apu_system_on,    system_out)
    set(apu_n1,           RPM)
    set(apu_air_doors,    bleed_doors_pos)
    set(apu_doors,        apu_doors_pos)
    set(apu_oil_t,        oil_temp)
    set(apu_oil_q,        oil_q)
    -- давление масла: нарастает при RPM > 15% (масляный насос)
    -- норма 3.8 кгс/см², мин 3.4 при +50°C (РЛЭ 8.2.1(3))
    -- давление масла по РЛЭ 8.2.1(3):
    -- норма 3.8 кгс/см² при +15°C, мин 3.4 при +50°C
    -- нарастает при RPM > 15% (масляный насос)
    local oil_press = oil_q * 3.8 * math.min(1, math.max(0, (RPM - 15) / 30))
    set(apu_oil_p,        oil_press)
    set(apu_egt,          egt)
    set(apu_fuel_p,       fuel_press)
    set(apu_start_cc,     start_cc)
    set(fuel_pumps_27_cc, fuel_current)
    set(apu_burn_fuel,    burning)
    set(apu_ready,        apu_is_ready)
    set(apu_start_phase,  phase)
    set(apu_cooldown,     cooldown_timer)

    -- сигнализация стартера
    set(apu_start_seq, starter_on)

    -- сигнализация для запуска двигателей от ВСУ
    set(apu_apd_working, (phase >= 5 and RPM > 90) and 1 or 0)
end
