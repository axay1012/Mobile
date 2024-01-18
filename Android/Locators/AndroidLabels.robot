*** Variables ***
#################### Mode List ################################
# --> HPWH Mode List
@{HPWH_modes_List}          Disabled    ENERGY SAVING    HEAT PUMP ONLY    HIGH DEMAND    ELECTRIC MODE


@{HPWHGen5_modes_List}      Off    Energy Saver    High Demand    Heat Pump    Electric    Vacation
@{HPWHGen5_State_List}      Disabled    Enabled
@{AltitudeValue}            Low Level    Med.Level    Sea Level

##################### Sign In page ###############################

${app_start_page_text}      Connecting you to greater savings, protection and convenience
${loginText}                Email Address
${passwordText}             Password
${EnvText}                  Staging
${saveText}                 Save
${sign_in_text}             Sign In
${create_text}              Create Account

####################### Menubar Options ##########################

${generalsettings_text}     General Settings
${Location_Text}            Location
${WarningMsgExpected}       CAUTION HOT WATER
${Msg_For_Energy_Saving}    This Equipment should be set to ENERGY SAVING Mode for maximum efficiency
${Location_per_text}        EcoNet collects location data to enable geofencing, even when the app is closed or not in use, to change modes and to notify you when you exit or enter the geofencing radius set in the app’s Away Settings

###################### Create Account ############################

${CreateAcc_Text}           Create an Account
${Email_Error_Msg}          Please enter valid email address.
${PhoneNo_Error_Msg}        Phone number must have valid digits.
${Pass_Error_Msg}           Password must be at least 8 characters long.
${ConfPass_Error_Msg}       Confirmation password doesn't match.
${validate_text}            Validate Your Account
${otp_validation}           Enter Your Code
${otp}                      111111
${account_text}             Your Account
${notification_text}        Notification Settings
${temperature_text}         Temperature Units
${Exit_text}                EXIT
${zone_page_text}           Zone Settings
${alexa_text}               Ask Alexa
${launch_alexa_text}        Launch Alexa App
${defaultwaittime}          10s

#### Device Objects #######

${deadband}                 DEADBAND
${statmode}                 STATMODE
${heatsetp}                 HEATSETP
${coolsetp}                 COOLSETP
${statnfan}                 STATNFAN
${away_mode}                AWAYMODE
${hvacmode}                 HVACMODE
${dispunit}                 DISPUNIT
${occupied}                 OCCUPIED
${whtrsetp}                 WHTRSETP
${whtrcnfg}                 WHTRCNFG
${vaca_net}                 VACA_NET
${chkAway}                  VACA_NET
${whtrenab}                 WHTRENAB
${comp_rly}                 COMP_RLY
${fan_ctrl}                 FAN_CTRL
${heatCtrl}                 HEATCTRL
${stat_fan}                 STAT_FAN
${burntime}                 BURNTIME
${altitude}                 ALTITUDE
${vacaenab}                 VACAENAB
${watersave}                WATRSAVE
${RPUMPMOD}                 RPUMPMOD
${HOTWATER}                 HOTWATER
