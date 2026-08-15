-- apu_heater.lua — наземный подогреватель ВСУ ТА-6А для Ту-154М
-- ============================================================
-- Имитация наземной подогревательной установки типа МП-85.
-- Прогрев масла ВСУ перед запуском при низких температурах
-- наружного воздуха (ниже -25°C по РЛЭ 8.2.1).
--
-- Условия работы:
--   - Самолёт на земле
--   - ВСУ выключена (RPM < 5%)
--   - Целевая температура: от -10 до +60 °C (с гистерезисом ±2°C)
--
-- Управление через датарефы:
--   sim/custom/apu_heater/on        — int, 0/1 (вкл/выкл)
--   sim/custom/apu_heater/target_t  — float, целевая температура, °C
--   sim/custom/apu_heater/active    — int, 1 = реально греет в данный момент
--
-- Чтобы включать/выключать — менять датареф sim/custom/apu_heater/on.
-- Самый простой путь — через DataRefEditor (плагин у тебя уже есть)
-- или повесить на хоткей через FlyWithLua скрипт.
--
-- Скорость нагрева — ускоренная (~3°C/сек) для геймплея.
-- В реале МП-85 прогревает ВСУ за 15-25 минут.
-- ============================================================

-- ============================================================
-- ДАТАРЕФЫ
-- ============================================================

-- состояние ВСУ
defineProperty("apu_n1",     globalPropertyf("sim/custom/eng/apu_n1"))
defineProperty("apu_oil_t",  globalPropertyf("sim/custom/eng/apu_oil_t"))

-- время кадра
defineProperty("frame_time", globalPropertyf("sim/custom/time/frame_time"))

-- состояние "на земле"
defineProperty("on_ground", globalPropertyi("sim/flightmodel/failures/onground_any"))

-- ============================================================
-- СОБСТВЕННЫЕ ДАТАРЕФЫ ПОДОГРЕВАТЕЛЯ (writable)
-- ============================================================
local heater_on_p     = createGlobalPropertyi("sim/custom/apu_heater/on",        0)
local heater_target_p = createGlobalPropertyf("sim/custom/apu_heater/target_t", 30)
local heater_active_p = createGlobalPropertyi("sim/custom/apu_heater/active",    0)

defineProperty("heater_on",     heater_on_p)
defineProperty("heater_target", heater_target_p)
defineProperty("heater_active", heater_active_p)

-- ============================================================
-- КОНСТАНТЫ
-- ============================================================
local HEAT_RATE       = 3.0   -- скорость нагрева масла, °C/сек (ускоренный режим)
local TARGET_MIN      = -10   -- мин. целевая температура, °C
local TARGET_MAX      = 60    -- макс. целевая температура, °C (РЛЭ — выше нельзя)
local HYSTERESIS      = 2.0   -- гистерезис регулятора, °C
local APU_OFF_RPM     = 5.0   -- RPM ниже которого ВСУ считается выключенной

-- ============================================================
-- ЛОГИКА ОБНОВЛЕНИЯ
-- ============================================================
local heating_now = false  -- внутренний флаг для гистерезиса

function update()
    local passed = get(frame_time)
    if passed <= 0 or passed > 0.5 then return end

    local rpm        = get(apu_n1)
    local oil_temp   = get(apu_oil_t)
    local target_t   = get(heater_target_p)
    local switch_on  = get(heater_on_p) == 1
    local on_grnd    = get(on_ground) == 1

    -- Ограничение целевой температуры
    if target_t > TARGET_MAX then
        set(heater_target_p, TARGET_MAX)
        target_t = TARGET_MAX
    elseif target_t < TARGET_MIN then
        set(heater_target_p, TARGET_MIN)
        target_t = TARGET_MIN
    end

    -- Автоматическое отключение
    if switch_on then
        if rpm >= APU_OFF_RPM then
            set(heater_on_p, 0)
            switch_on = false
            heating_now = false
        elseif not on_grnd then
            set(heater_on_p, 0)
            switch_on = false
            heating_now = false
        end
    end

    -- Регулятор с гистерезисом
    if switch_on then
        if heating_now then
            if oil_temp >= target_t then
                heating_now = false
            end
        else
            if oil_temp <= (target_t - HYSTERESIS) then
                heating_now = true
            end
        end

        if heating_now then
            oil_temp = oil_temp + HEAT_RATE * passed
            if oil_temp > target_t then oil_temp = target_t end
            set(apu_oil_t, oil_temp)
            set(heater_active_p, 1)
        else
            set(heater_active_p, 0)
        end
    else
        heating_now = false
        set(heater_active_p, 0)
    end
end
