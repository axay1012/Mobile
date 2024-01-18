*** Variables ***

${elementsTimeout}                  10s
@{HPWH_modes}                       OFF    ENERGY SAVING    HEAT PUMP ONLY    HIGH DEMAND    ELECTRIC MODE
@{HPWH_Gen5_modes}                  Off    Energy Saver    Heat Pump    High Demand    Electric    Vacation
@{Niagara_modes}                    Disabled    Enabled
@{Eagle_modes}                      Disabled    Enabled
@{HotSpring_modes}                  Disabled    Enabled
@{Triton_modes}                     Disabled    Enabled
@{Electric_modes}                   Disabled    Enabled
@{schedule_modes}                   Unoccupied    Occupied
@{ElectricHeaterMode}               Energy Saver    Performance
@{shuttOffVal}                      0    1
${defaultStatusElectric}            false
@{fan_Speed}                        Auto    Low    Med.Lo    Medium    Med.Hi    High
@{ECC_modes}                        Heating    Cooling    Auto    Fan Only    Off    Emergency Heat
@{AltitudeLevels}                   Sea Level    Low Altitude    Med.Altitude    High Altitude
@{RecircPumpModes}                  None    Timer-Perf.    Timer-E-Save    On-Demand    Schedule
@{RecircPumpModes1}                 None    Timer-Perf.    Timer-E-Save    On-Demand
@{AltitudeValue}                    Low Level    Med.Level    Sea Level

###################    First screen    ###################

${homepage_text}                    Connecting you to greater savings, protection and convenience

##################    Sign in    #############
${signin_page_text}                 Please sign in below
${awayModeText}                     I'm Away
${homeModeText}                     I'm Home
${expectedCautionMessage}           CAUTION HOT WATER. Contact may cause serious burns to skin
${cautionhotwater}                  CAUTION HOT WATER
${contactskinburn}                  Contact may cause serious burns to skin
${followScheduleMsgDashboard}       //XCUIElementTypeStaticText[@value="Following Schedule"]
${scheduleOverriddenMsg}            Schedule overridden
${notFollowingScheduleMsg}          Not Following Schedule
${copyPageText}                     //XCUIElementTypeNavigationBar[@name="Copy Day Settings"]
${locationNameNiagara}              %{Niagra_Location_Name}
${locationNameHPWH}                 %{HPWH_Location_Name}
${locationNameThor}                 %{Thor_Location_Name}
${locationNameHPWHGen5}             %{HPWHGen5_Location_Name}
${locationNameHotSpring}            %{HotSpring_Location_Name}
${locationNameTriton}               %{Triton_Location_Name}
${locationNameElectric}             %{Electric_Location_Name}
${locationNameNewECC}               %{NewECC_Location_Name}
#${locationNameIkonic}               %{Ikonic_Location_Name}
${locationNameOldECC}               %{OldECC_Location_Name}
${locationNameZoning}               %{Zone_Location_Name}
${locationNameEagle}                %{Eagle_Location_Name}
${locationNameDragon}               %{Dragon_Location_Name}
#${locationNameGASWH}                %{Gas_Location_Name}
${locationTest}                     Test
${zipCode}                          38001
${invalidEmailMessage}              Please enter a valid email address.
${msgInvalidEmail}                  Please enter valid email.
${msgInvalidNumber}                 Please enter valid phone number.
${msgInvalidPassword}               Password must be at least 8 characters long.
${msgInvalidConfrmPassword}         Confirmation password does not match.

${txtOk}                            Ok
${defaultWaitTime}                  20s
${deviceResponseWaitTime}           60
${RunningStatus}                    Running

#### Device Objects #######

${deadband}                         DEADBAND
${statmode}                         STATMODE
${heatsetp}                         HEATSETP
${coolsetp}                         COOLSETP
${statnfan}                         STATNFAN
${away_mode}                        AWAYMODE
${hvacmode}                         HVACMODE
${dispunit}                         DISPUNIT
${occupied}                         OCCUPIED

${whtrsetp}                         WHTRSETP
${whtrcnfg}                         WHTRCNFG
${vaca_net}                         VACA_NET
${chkAway}                          VACA_NET
${whtrenab}                         WHTRENAB
${comp_rly}                         COMP_RLY
${fan_ctrl}                         FAN_CTRL
${heatCtrl}                         HEATCTRL
${stat_fan}                         STAT_FAN
${burntime}                         BURNTIME
${altitude}                         ALTITUDE
${vacaenab}                         VACAENAB
${watersave}                        WATRSAVE
${RPUMPMOD}                         RPUMPMOD
${HOTWATER}                         HOTWATER

${Account_Action_Required}    Account Action Required
${SuccessMsges}               EcoNetAutomationTesting will email you with more information.
${Enrollment_Pending}         Enrollment Pending
${Status:}                    Status:
${Account_Active}             Account Active
${ExitLabel}                  Exit

${ErrPhoneNumberValiddigits}    Phone number must have valid digits.
${ErrValidEmailAddress}         Please enter a valid email address.
${ErrPasswordConfirmPasswordnotmatch}  Password and Confirm Password didn't match.
${LabelPhoneNumber}        Phone Number
${LabelPassword}           Password
${LabelAddress}            Address