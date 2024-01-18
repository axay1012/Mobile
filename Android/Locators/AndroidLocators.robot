*** Settings ***
Documentation       This robot file consist of different locators of Rheem android application.


*** Variables ***
${xPathPrefix}                          //
${progressBarClass}                     android.widget.ProgressBar
${textViewClass}                        android.widget.TextView
${imageButtonClass}                     android.widget.ImageButton
${calendarViewClass}                    android.widget.CalendarView
${checkedTextViewClass}                 android.widget.CheckedTextView
${compoundButtonClass}                  android.widget.CompoundButton
${expandableListViewClass}              android.widget.ExpandableListView
${listPopupWindowClass}                 android.widget.ListPopupWindow
${popupMenuClass}                       android.widget.PopupMenu
${popupWindowClass}                     android.widget.PopupWindow
${filterClass}                          android.widget.Filter
${numberPickerClass}                    android.widget.NumberPicker
${filterResultsClass}                   android.widget.Filter.FilterResults
${gridLayoutClass}                      android.widget.GridLayout
${gridViewClass}                        android.widget.GridView
${relativeLayoutClass}                  android.widget.RelativeLayout
${linearLayoutClass}                    android.widget.LinearLayout
${switchClass}                          android.widget.Switch
${toolBarClass}                         android.widget.Toolbar
${videoViewClass}                       android.widget.VideoView
${viewAnimatorClass}                    android.widget.ViewAnimator
${viewSwitcherClass}                    android.widget.ViewSwitcher
${scrollViewClass}                      android.widget.ScrollView
${scrollerClass}                        android.widget.Scroller
${searchViewClass}                      android.widget.SearchView
${spinnerClass}                         android.widget.Spinner
${buttonClass}                          android.widget.Button
${editTextClass}                        android.widget.EditText
${imageViewClass}                       android.widget.ImageView
${imageViewButton}                      android.widget.ImageButton
${frameLayoutClass}                     android.widget.FrameLayout
${checkBoxClass}                        android.widget.CheckBox
${listViewClass}                        android.widget.ListView
${radioGroupClass}                      android.widget.RadioGroup
${ratingBarClass}                       android.widget.RatingBar
${radioButtonClass}                     android.widget.RadioButton
${viewClass}                            android.view.View
${seekbarClass}                         android.widget.SeekBar
${viewgroup}                            android.view.ViewGroup
${RecycleView}                          androidx.recyclerview.widget.RecyclerView
${Compactview}                          androidx.appcompat.widget.LinearLayoutCompat
${webViewClass}                         android.webkit.WebView

################################# Rheem Package Name ###############################
${Rheem_Package}                        com.rheem.econetconsumerandroid
${Rheem_permission_control}             com.android.permissioncontroller

################################ Reskin Application Locators ############################
${imageLogo}                            ${xPathPrefix}${imageViewClass}\[@resource-id='${Rheem_Package}:id/welcomeLogo']
# ${SignIn_Button}    ${xPathPrefix}${textview}\[@resource-id = '${EconetPackage}:id/signinText']
# ${SignIn_Button}    ${xPathPrefix}android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/signinText']
${SignIn_Button}                        ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/signinText']
${userName}                             ${xPathPrefix}${editTextClass}\[@resource-id='${Rheem_Package}:id/login_email_text']
${password}                             ${xPathPrefix}${editTextClass}\[@resource-id='${Rheem_Package}:id/login_password_text']
${loginButton}                          ${xPathPrefix}${buttonClass}\[@resource-id='${Rheem_Package}:id/uikit_rectangle_button']
${notification_icon}                    ${xPathPrefix}${imageViewClass}\[@resource-id='${Rheem_Package}:id/actionIcon']
${menu_bar}                             ${xPathPrefix}${imageViewButton}\[@content-desc = "Open navigation drawer"]
${Temperature_unit}                     ${xPathPrefix}${viewgroup}\[@resource-id='${Rheem_Package}:id/generalSettingTemperatureUnits']
${Fahrenheit_unit}                      ${xPathPrefix}${RecycleView}\[@resource-id='${Rheem_Package}:id/checkableRecycleView']/android.view.ViewGroup[@index='1']
${Celsius_unit}                         ${xPathPrefix}${RecycleView}\[@resource-id='${Rheem_Package}:id/checkableRecycleView']/android.view.ViewGroup[@index='0']
${WH_get_EC_SetPointValue}              ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/whSetPointText']
${WH_get_SetPointValue}                 ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/valueCurrentTemperature']
${WH_Temp_WarningMsg}                   ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/tvWarningAlert']
${WH_changemode}                        ${xPathPrefix}${viewgroup}\[@resource-id='${Rheem_Package}:id/linearLayout']
${WH_get_Eqipment_Mode}                 ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/whModeText']
${Energy_Saver_Msg}                     ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/wBannerMessage']
${Energy_Saving_Enable_Button}          ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/wBannerButton']
${WH_product_setting}                   ${xPathPrefix}${frameLayoutClass}\[@resource-id='${Rheem_Package}:id/whBottomMenu']/android.view.ViewGroup[@index='0']
${get_Usage_Report_data}                ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/vtUsageText']
${HistoricalData_Switch}                ${xPathPrefix}${switchClass}\[@resource-id='${Rheem_Package}:id/historicalDataSwitch']
${Full_Screen_Mode}                     ${xPathPrefix}${imageButtonClass}\[@resource-id='${Rheem_Package}:id/buttonRotateGraph']
${Usage_Chart}                          ${xPathPrefix}${viewgroup}\[@resource-id='${Rheem_Package}:id/chart']
${get_Away_status}                      ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/location_title']
${Location_Away_icon}                   ${xPathPrefix}${imageViewClass}\[@resource-id='${Rheem_Package}:id/location_image']
${location_name_Away_config}            ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/rawHomeAwayLocationName']
${Away_eqp_switch}                      ${xPathPrefix}${switchClass}\[@resource-id='${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']
${temp0}                                ${xPathPrefix}android.view.ViewGroup[@index='0']/android.widget.LinearLayout[@index='1']/android.widget.TextView[@index='0']
${temp1}                                ${xPathPrefix}android.view.ViewGroup[@index='1']/android.widget.LinearLayout[@index='1']/android.widget.TextView[@index='0']
${temp2}                                ${xPathPrefix}android.view.ViewGroup[@index='2']/android.widget.LinearLayout[@index='1']/android.widget.TextView[@index='0']
${temp3}                                ${xPathPrefix}android.view.ViewGroup[@index='3']/android.widget.LinearLayout[@index='1']/android.widget.TextView[@index='0']
${time0}                                ${xPathPrefix}android.view.ViewGroup[@index='0']/android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/timeText']
${time1}                                ${xPathPrefix}android.view.ViewGroup[@index='1']/android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/timeText']
${time2}                                ${xPathPrefix}android.view.ViewGroup[@index='2']/android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/timeText']
${time3}                                ${xPathPrefix}android.view.ViewGroup[@index='3']/android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/timeText']
${ScheduleTime_Temp}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/valueCurrentTemperature']
${ScheduleTime_Mode}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/modeValue']
${FollowSchedule_button}                ${xPathPrefix}${switchClass}\[@resource-id = '${Rheem_Package}:id/inflateSwitch']
${click_copy}                           ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/includeHeaderSkip']
${Off_mode}                             ${xPathPrefix}android.view.ViewGroup\[@resource-id='com.rheem.econetconsumerandroid:id/llModes' and @index='4']
${Energy_mode}                          ${xPathPrefix}android.view.ViewGroup\[@resource-id='com.rheem.econetconsumerandroid:id/llModes' and @index='1']
${Heatpump_mode}                        ${xPathPrefix}android.view.ViewGroup\[@resource-id='com.rheem.econetconsumerandroid:id/llModes' and @index='2']
${Highdemand_mode}                      ${xPathPrefix}android.view.ViewGroup\[@resource-id='com.rheem.econetconsumerandroid:id/llModes' and @index='3']
${Electric_mode}                        ${xPathPrefix}android.view.ViewGroup\[@resource-id='com.rheem.econetconsumerandroid:id/llModes' and @index='4']
${Resume_Button}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/ovalButton']
${TempInc_Button}                       ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/wheel_plus_button']
${TempDec_Button}                       ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/wheel_minus_button']
${Mode_Change}                          ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/buttonWhMode']
${Mode_Value}                           ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/buttonWhMode']/android.view.ViewGroup[@index='0']/android.widget.FrameLayout[@index='0']/android.view.ViewGroup[@index='0']/android.widget.TextView[@resource-id = '${Rheem_Package}:id/deviceControlValue']
${Energy_Saver_Msg}                     ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/wBannerMessage']
${Dis/Ena_State}                        com.rheem.econetconsumerandroid:id/item_state
${DiagnosticMode}                       ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/diagnosticModeText']
${SelectProduct}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/rcyViewConnection']/android.view.ViewGroup[@index="1"]
# ${First_Name}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyFirstName']
# ${Last_Name}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyLastName']
# ${Email_Address}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyEmailAddress']
# ${Phone_Number}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyPhoneNumber']
${AddressCA}                            ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterAddress']
${CityCA}                               ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterCity']
${StateCA}                              ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterState']
${Postal_CodeCA}                        ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterPostalCode']
# ${Password}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyPassword']
# ${Confirm_Password}    ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/inputLyConfirmPassword']
# ${CheckBox}    ${xPathPrefix}${checkBoxClass}\[@resource-id = '${Rheem_Package}:id/uikit_checkbox']
# ${SeePassword}    ${xPathPrefix}${imageButtonClass}\[@resource-id = '${Rheem_Package}:id/text_input_end_icon']
${Schedule_Data}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/schedule_day_list']
${GetTime}                              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/schedule_day_list']/android.view.ViewGroup[index='
${COPY_Click}                           ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/includeHeaderSkip']
${DaysList}                             ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/copyScheduleContainer']
${Electric_ModeCard}                    ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/buttonWhMode']
${Select_Energy_Mode}                   ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='0']
${Select_Performance_Mode}              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='1']
${GetMode_EC}                           ${xPathPrefix}${textViewClass}\[@resource-id="com.rheem.econetconsumerandroid:id/whModeText"]
${GetState_EC}                          ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/whCardView']/android.view.ViewGroup[@index='0']/android.widget.LinearLayout[@index='2']/android.widget.TextView[@index='3']
${Occ/Unocc_Switch}                     ${xPathPrefix}${switchClass}\[@resource-id = '${Rheem_Package}:id/timeSlotSwitcher']
${AltitudeLevelDropDown}                ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/textTitleHeaderRecyclerView']/android.view.ViewGroup[@index='1']
${SeaLevel}                             ${xPathPrefix}android.view.ViewGroup[@index='0']
${Med.Altitude}                         ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='2']/android.widget.TextView[@index='0']
${High Altitude}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='3']/android.widget.TextView[@index='0']
${RecircDropDown}                       ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/textTitleHeaderRecyclerView']/android.view.ViewGroup[@index='0']
${NoneMode}                             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='0']/android.widget.TextView[@index='0']
${Timer-Perf}                           ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='1']/android.widget.TextView[@index='0']
${On-Demand}                            ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='3']/android.widget.TextView[@index='0']
${Schedule}                             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='4']/android.widget.TextView[@index='0']
${Dragon_RecircPump_Config}             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/waterHeaterDynamicListRecyclerView']/android.view.ViewGroup[@index='0']/androidx.recyclerview.widget.RecyclerView[@index='1']/android.view.ViewGroup[@index='0']/android.widget.TextView[@index='1']
${Dragon_ShutoffValve_Config}           ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/waterHeaterDynamicListRecyclerView']/android.view.ViewGroup[@index='1']/androidx.recyclerview.widget.RecyclerView[@index='1']/android.view.ViewGroup[@index='0']/android.widget.TextView[@index='1']
${ClosedifLeakDetected}                 ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='0']
${ClosedifUnoccLeakDetect}              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='1']
${Open}                                 ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='2']
${Closed}                               ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='3']
${RecircON}                             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='1']
${RecircScheduleOn}                     ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='3']
${RecircOnDemand}                       ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='4']
${AlarmOnly}                            ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/waterHeaterDynamicListRecyclerView']/android.view.ViewGroup[@index='2']/androidx.recyclerview.widget.RecyclerView[@index='1']/android.widget.LinearLayout[@index='0']/android.widget.LinearLayout[@index='0']/android.view.ViewGroup[@index='0']
${DisableWH}                            ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/waterHeaterDynamicListRecyclerView']/android.view.ViewGroup[@index='2']/androidx.recyclerview.widget.RecyclerView[@index='1']/android.widget.LinearLayout[@index='0']/android.widget.LinearLayout[@index='0']/android.view.ViewGroup[@index='1']
${HVAC_FanSpeed}                        ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/control_buttons']/android.widget.FrameLayout[@index='0']
${HVAC_Mode}                            Mode
${HVAC_Humidity}                        ${xPathPrefix}${viewClass}\[@resource-id = '${Rheem_Package}:id/control_buttons']/android.widget.FrameLayout[@index='2']
${Heating_Mode}                         ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='0']
${Cooling_Mode}                         ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='1']
${Auto_Mode}                            ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='2']
${FanOnly_Mode}                         ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='3']
# ${Off_mode}    ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.view.ViewGroup[@index='4']
${HVACMode_EquipmentCard}               ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/hvacModeText']
${HVACFanSpeed_EquipmentCard}           ${xPathPrefix}android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/hvacFanText"]
${HVACHUmidity_EquipmentCard}           ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/hvacStatusLayout']/android.widget.TextView[@index='1']
${HAVCHeatTemp_Equipmentcard}           ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/hvacHeatText']
${HAVCCoolTemp_Equipmentcard}           ${xPathPrefix}${textviewClass}\[@resource-id = '${Rheem_Package}:id/hvacCoolText']
${HVACOffText_Equipmentcard}            ${xPathPrefix}android.widget.TextView\[@resource-id = '${Rheem_Package}:id/hvacDisconnectText']
${AwayHVAC_CoolTemp}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/valueCoolTo']
${AwayHVAC_FanSpeed}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/rawHomeAwayValue']
${Buttonslider}                         ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/switch_to_buttons']
${HVACAway_HeatButton}                  ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/heating_panel']/android.view.ViewGroup[@index='0']
${HVACAway_CoolButton}                  ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/cooling_panel']/android.view.ViewGroup[@index='0']
${Schedule_FanSpeed}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/modeValue']
${Schedule_FanSpeed}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/modeValue']
${Cool_Increase}                        ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/cooling_panel']/android.view.ViewGroup[@index='0']
${Heat_Increase}                        ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/heating_panel']/android.view.ViewGroup[@index='0']
${Cool_Decrease}                        ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/cooling_panel']/android.view.ViewGroup[@index='0']
${Heat_Decrease}                        ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/heating_panel']/android.view.ViewGroup[@index='0']

${Heat_temp_Value}                      ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/heating_panel']
# ${Heat_temp_Value}    /hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[1]/android.view.ViewGroup/android.widget.FrameLayout[1]/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView[2]
${Cool_temp_Value}                      ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/cooling_panel']
# ${Cool_temp_Value}    /hierarchy/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.widget.LinearLayout/android.widget.FrameLayout/android.view.ViewGroup/android.widget.ScrollView/android.view.ViewGroup/android.view.ViewGroup[1]/android.widget.FrameLayout/android.view.ViewGroup/android.widget.FrameLayout[1]/android.view.ViewGroup/android.widget.FrameLayout[3]/android.view.ViewGroup/android.view.ViewGroup/android.widget.TextView[2]

############################################ Newlocators #######################################################
${imageLogo}                            ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/welcomeLogo']
# ${Select_HPWH_location}    ${xPathPrefix}${textViewClass}\[@text='HPWH']
# ${select_HPWH5_location}    ${xPathPrefix}${textViewClass}\[@text='HPWHGen5']
${select_HPWH_location_details}         Heat Pump Water Heater
${Increment_Temp}                       ${xPathPrefix}${viewClass}\[@resource-id = '${Rheem_Package}:id/wheel_plus_button']
${Decrement_Temp}                       ${xPathPrefix}${viewClass}\[@resource-id = '${Rheem_Package}:id/wheel_minus_button']
# ${setpoint_M_DP}    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/valueCurrentTemperature']
${UsageReport_text}                     Usage
########################################## HPWHGEN4 locators #####################################################
# ${OFF_Mode}    OFF

${Heatpump_Text}                        ${xPathPrefix}${textViewClass}\[@text='HEAT PUMP ONLY']
${Disabled_Text}                        com.rheem.econetconsumerandroid:id/valueCurrentTemperature
${Save_button}                          Save Schedule

############################################ Menubar Options #######################################################
${Profile}                              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='1']
${Notifications}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='2']
${General}                              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='3']
${SignOut}                              ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='4']
${Locations&Products}                   ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='6']
${ZoneNames}                            ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='7']
${AwaySettings}                         ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='8']
${ScheduledAway/Vacation}               ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='9']
${AskAlexa}                             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='11']
${Contacts}                             ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='13']
${FAQ}                                  ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='14']
${PrivacyNotice}                        ${xPathPrefix}${RecycleView}\[@resource-id = '${Rheem_Package}:id/menuRecyclerView']/android.widget.FrameLayout[@index='15']

${GeoFencing}                           ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/settingsSwitchTitle']
${DistanceUnit}                         ${xPathPrefix}${viewClass}\[@resource-id = '${Rheem_Package}:id/settingsDistanceUnit']

######################################## App Features #################################################
${Create_account}                       ${xPathPrefix}${textViewClass}\[@text = 'Create account']
${first_name}                           ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvFirstName']
${last_name}                            ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvLastName']
${email_Add}                            ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterEmail']
${Phone_Number}                         ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterPhone']
${country}                              ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/countryField']
${Acc_Pass}                             ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterPass']
${See_Pass}                             ${xPathPrefix}${imageButtonClass}\[@resource-id = '${Rheem_Package}:id/text_input_end_icon']
${Confirm_Pass}                         ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/tvRegisterConfirmPass']
${check_box}                            ${xPathPrefix}${checkBoxClass}\[@resource-id = '${Rheem_Package}:id/uikit_checkbox']
${OTP_number}                           ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/otp_view']
${menu_bar}                             ${xPathPrefix}${viewgroup}\[@resource-id = '${Rheem_Package}:id/dashboard_toolbar']
${log_out}                              ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/expandableListView']
${Forgot_Pass}                          ${xPathPrefix}${buttonClass}\[@resource-id = '${Rheem_Package}:id/forgot_password_button']
${enter_email_num}                      ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/edtPhoneNumber']
${forgot_submit_button}                 ${xPathPrefix}${buttonClass}\[@resource-id = '${Rheem_Package}:id/submitButton']
${Change_pass}                          ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/edtChangePassword']
${edit_confirm_pass}                    ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/edtConfirmPassword']
${save_button}                          ${xPathPrefix}${buttonClass}\[@resource-id = '${Rheem_Package}:id/saveButton']
${Your_Profile}                         ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/expandableListView']
${get_email}                            ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/dropdownValue']
${get_phone_num}                        ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/yourProfilePhoneText']
${change_num}                           ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/changePhoneNewPhoneNumberEdt']
${conf_num}                             ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/changePhoneConfirmNewPhoneNumberEdt']
${current_pass}                         ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/updatePasswordCurrentPasswordEdt']
${new_pass}                             ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/updatePasswordNewPasswordEdt']
${conf_pass}                            ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/updatePasswordConfirmPasswordEdt']
${notification_settings}                ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/expandableListView']
${check_box1}                           ${xPathPrefix}${switchClass}\[@resource-id = '${Rheem_Package}:id/settingsSwitch']
${check_box2}                           ${xPathPrefix}${checkBoxClass}\[@resource-id = '${Rheem_Package}:id/notificationSettingAlertText']
${check_box3}                           ${xPathPrefix}${checkBoxClass}\[@resource-id = '${Rheem_Package}:id/notificationSettingSpecialOfferEmails']
${text1}                                ${xPathPrefix}${textViewClass}\[@text= 'Special Offer Emails']
${Celsius_unit}                         ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/generalSettingCelciusTxt']
${Fahrenheit_unit}                      ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/generalSettingFahrenheitTxt']
${asked_questions}                      ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/expandableListView']/android.widget.LinearLayout[@index='10']
${Away_switch}                          ${xPathPrefix}${switchClass}\[@resource-id = '${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']
${contractor_phone}                     ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/addItemContractorPhone']
${edit_icon}                            ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/imgEditContractor']
${edit_contractor_email}                ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/editItemContractorEmail']
${edit_contractor_phone}                ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/editItemContractorPhone']
${next_button}                          ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/addLocationNextTxt']
${use_current_location}                 ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/addLocationCurrentLocationText']
${location_edit}                        ${xPathPrefix}android.widget.ImageView\[@resource-id='com.rheem.econetconsumerandroid:id/includePencilIcon']
${deleteLocationICon}                   ${xPathPrefix}android.widget.ImageView\[@resource-id='com.rheem.econetconsumerandroid:id/trashIcon']
${edit_location_name}                   ${xPathPrefix}${editTextClass}\[@resource-id = 'com.rheem.econetconsumerandroid:id/nameEditText']
${manage_zone}                          ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/expandableListView']
${edit_zone_name}                       ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/editItem']
${notification_alert}                   ${xPathPrefix}${expandableListViewClass}\[@resource-id = '${Rheem_Package}:id/locationAlertExpandableListView']
${img_alert_icon}                       ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/imgAlertIcon']
${Away_switch1}                         ${xPathPrefix}${linearLayoutClass}\[@index= '1']/android.widget.LinearLayout[@index='0']/android.widget.Switch[@resource-id='${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']
${Away_switch2}                         ${xPathPrefix}${linearLayoutClass}\[@index= '2']/android.widget.LinearLayout[@index='0']/android.widget.Switch[@resource-id='${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']
${Away_switch3}                         ${xPathPrefix}${linearLayoutClass}\[@index= '3']/android.widget.LinearLayout[@index='0']/android.widget.Switch[@resource-id='${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']
${validate_button}                      ${xPathPrefix}${buttonClass}\[@resource-id = '${Rheem_Package}:id/resetPassButton']
${schedule_msg}                         ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/inflateTextLabel']
${health_seekbar}                       ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/segmentedProgressbarLayout']
${progressbar_1}                        ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/segmentedProgressbarLayout']
${Change_Name}                          ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/yourProfileChangeFirstNameText']
${Name_First}                           ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/changeCurrentFirstNameEditTextInputLayout']
${Name_Second}                          ${xPathPrefix}${linearLayoutClass}\[@resource-id = '${Rheem_Package}:id/changeCurrentLastNameEditTextInputLayout']
${Save_Changes}                         ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/save_name']
${change_first_name}                    ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/changeCurrentFirstNameEdit']
${change_last_name}                     ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/changeCurrentLastNameEdit']
${Create_account_location}              ${xPathPrefix}${imageButtonClass}\[@resource-id = '${Rheem_Package}:id/text_input_end_icon']

############################################# AppFeatures Add new Locators of Error validation Msg ################################################
${Error_Email_msg}                      ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/textinput_error']
${Resume_Button}                        ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/dynamic_button_view']
${edit_button}                          ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/imgEdit']
${Edit_product_name}                    ${xPathPrefix}android.widget.ImageView[@resource-id="com.rheem.econetconsumerandroid:id/includePencilIcon"]
${button_OK}                            ${xPathPrefix}${buttonClass}\[@resource-id = 'android:id/button1']
${running_sts_label}                    ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/inflateTextLabel']
${click_notification_icon}              ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/menu_notification']/android.widget.ImageView[@index=0]
${Continue_Button}                      ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/connectionContinueTxt']
${back}                                 ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/connectionBackTxt']

################################ Geo Fencing ######################################
${GeoFencing_Switch}                    ${xPathPrefix}android.widget.Switch\[@resource-id='com.rheem.econetconsumerandroid:id/settingsSwitch']
${Location_List}                        ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/fragmentModeRecycler']/android.widget.LinearLayout[@index='0']
${DistanceUnit_GeoFencing}              ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/selectDistanceUnit']
${Home/Away_Radius}                     ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/setHomeOrAwayRadiusText']
${Away_Icon_Dashboard}                  ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/whCardHomeAwayImg']
${get_location_button}                  ${xPathPrefix}${textViewClass}\[@resource-id = '${Rheem_Package}:id/locationSelectionTxt']

${location_notification_ok}             OK
${location_per}                         While using the app
${WH_product_setting}                   Schedule

${schedule_button}                      com.rheem.econetconsumerandroid:id/bottom_button_icon

${GetModeText_DP}                       ${xPathPrefix}android.view.ViewGroup[@resource-id='com.rheem.econetconsumerandroid:id/linearLayout']/android.widget.TextView[@index='2']

${contractor_checkbox}                  ${xPathPrefix}${checkBoxClass}\[@resource-id = '${Rheem_Package}:id/checkboxWH']
${New_contactor_Name}                   ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/addNameContractorTextInputEditText']
${New_contactor_Mail}                   ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/addMailContractorTextInputEditText']
${New_contactor_Phonenumber}            ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/addPhoneContractorTextInputEditText']
${away_toggel_button}                   ${xPathPrefix}${switchClass}\[@resource-id = '${Rheem_Package}:id/rawHomeAwayEquipmentSwitch']

${Electic_L}                            Electric
${HPWHGEN5_L}                           Niagara

${Schedule_mode}                        com.rheem.econetconsumerandroid:id/modeValue
${Contarctor_field}                     com.rheem.econetconsumerandroid:id/rightArrowView
${edit_contractor_button}               com.rheem.econetconsumerandroid:id/includeHeaderSecondButton
${get_contractor_email}                 com.rheem.econetconsumerandroid:id/viewMail
${get_contractor_phone}                 com.rheem.econetconsumerandroid:id/viewPhoneNumber
${Delete_button}                        com.rheem.econetconsumerandroid:id/includeHeaderFirstButton

${create_account_button}                ${xPathPrefix}${buttonClass}\[@resource-id = '${Rheem_Package}:id/uikit_rectangle_button']
${ok_button_validation}                 android:id/button1
${location_permission_validation}       com.android.permissioncontroller:id/permission_allow_foreground_only_button
${success}                              com.rheem.econetconsumerandroid:id/alertTitle

############################################# Network Settings ########################################################
${Settings_Details}                     ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/item_network_settings']
${MAC_Address}                          ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/inflatetextTitleTv']
${Wifi_Software Version}                ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/inflatetextTitleTv']/android.widget.TextView[@index='2']
${Network_SSID}                         ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/inflatetextTitleTv']/android.widget.TextView[@index='4']
${IP_Address}                           ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/inflatetextTitleTv']/android.widget.TextView[@index='6']

###########################################    Schedule ##############################################
${current_schedule_Temp}                ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/valueCurrentTemperature']
# ${status}    ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}
${device notification}                  ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/whNotificationIcon']
${Choose_Contractor}                    ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/chooseContractorTitle']
${Alert_list}                           ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/itemAlertSummery']

######################################### Usage Data ###########################################################
${Select_Energyconsumption}             ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/consumptionSelectButton']
${Daily_Usage}                          ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/tabLayoutDaily']
${Weekly_Usage}                         ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/tabLayoutWeekly']
${Monthly_Usage}                        ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}:id/tabLayoutMonthly']
${Yearly_Usage}                         ${xPathPrefix}${textViewClass}\[@resource-id='${Rheem_Package}::id/tabLayoutYearly']
${Full_Chart}                           ${xPathPrefix}${viewgroup}\[@resource-id = '${Rheem_Package}:id/chart']
${Usage_Text}                           You've used 0 Gal of water
####################################### Triton WH locators #######################################################
${Select_Triton_location}               Triton
${Usage_Report_Select}                  ${xPathPrefix}${frameLayoutClass}\[@resource-id = '${Rheem_Package}:id/item_report']
${Select_Water_Usage}                   ${xPathPrefix}${textViewClass}\[@text='Water']

##################################### App Feature ##############
${schedule_away_pop}                    Scheduled Away/Vacation
${away_setting_pop}                     Away Settings
${Zip_code_New}                         ${xPathPrefix}${editTextClass}\[@resource-id = '${Rheem_Package}:id/inputZipCodeEdit']
${new_location_edit}                    ${xPathPrefix}${imageViewClass}\[@resource-id = '${Rheem_Package}:id/includePencilIcon']
${delete_account_button}                com.rheem.econetconsumerandroid:id/deleteProfile
${delete_account}                       android:id/button1
${back_screen}                          ${xPathPrefix}${imageViewClass}\[@resource-id='${Rheem_Package}:id/includeHeaderBack']

${SwitchToButton}                       ${xPathPrefix}android.widget.FrameLayout[@resource-id='com.rheem.econetconsumerandroid:id/switchButton']
${HeatPlusButton}                       ${xPathPrefix}android.view.View[@resource-id='com.rheem.econetconsumerandroid:id/wheel_plus_button']
${CoolPlusButton}                       ${xPathPrefix}android.view.View[@resource-id='com.rheem.econetconsumerandroid:id/wheel_plus_button']
${HeatMinusButton}                      ${xPathPrefix}android.view.View[@resource-id='com.rheem.econetconsumerandroid:id/wheel_minus_button']
${CoolMinusButton}                      ${xPathPrefix}android.view.View[@resource-id='com.rheem.econetconsumerandroid:id/wheel_minus_button' and @index='15']
${HeatButtonSetPoint}                   ${xPathPrefix}android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/text_temperature']
${CoolButtonSetPoint}                   ${xPathPrefix}android.widget.TextView[@text="COOL TO"]/following-sibling::android.widget.TextView
${AwayHVAC_HeatTemp}                    ${xPathPrefix}android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/valueHeatTo']
${ChangePhnNumberTextBox}               ${xPathPrefix}android.widget.EditText[@resource-id='com.rheem.econetconsumerandroid:id/changePhoneNewPhoneNumberEdit']
${notification_alert_text}              ${xPathPrefix}android.view.ViewGroup[@index='1']
${ZoneNameEdit}                         ${xPathPrefix}android.widget.EditText[@resource-id='com.rheem.econetconsumerandroid:id/deviceNameEdit']

${CA_current_location}                  com.rheem.econetconsumerandroid:id/text_input_end_icon
${CA_current_location}                  com.rheem.econetconsumerandroid:id/text_input_end_icon
${SSIDEdit}                             ${xPathPrefix}android.widget.ImageView[@resource-id='com.rheem.econetconsumerandroid:id/settingsStoredSSIDEdit']
${Awaytoggleswitch}                     ${xPathPrefix}android.widget.Switch[@resource-id="com.rheem.econetconsumerandroid:id/rawHomeAwayEquipmentSwitch"]
${ZoneModeDP}                           ${xPathPrefix}android.widget.FrameLayout[@resource-id="com.rheem.econetconsumerandroid:id/button_control_mode"]/android.view.ViewGroup[@resource-id="com.rheem.econetconsumerandroid:id/linearLayout"]/following-sibling::android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/deviceControlValue"]

${day_Tuesday}                          Tuesday
${day_Wednesday}                        Wednesday
${day_Thursday}                         Thursday
${day_Friday}                           Friday
${day_Saturday}                         Saturday
${day_Sunday}                           Sunday
${day_Monday}                           Monday

${sunday}                               SUN
${monday}                               MON
${tuesday}                              TUE
${wednesday}                            WED
${thursday}                             THU
${friday}                               FRI
${saturday}                             SAT

${WH_EquipmentCard}                     ${xPathPrefix}android.widget.TextView[@resource-id='com.rheem.econetconsumerandroid:id/whDeviceTitle']
${whDisconnectText}                     ${xPathPrefix}android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/whDisconnectText"]
${whStateText}                          ${xPathPrefix}android.widget.TextView[@resource-id="com.rheem.econetconsumerandroid:id/whStateText"]

${DRLocationSelection}                  ${xPathPrefix}android.view.ViewGroup[@resource-id="com.rheem.econetconsumerandroid:id/locationHolder"]
${DRProgramCard}        ${xPathPrefix}android.widget.FrameLayout[@resource-id="com.rheem.econetconsumerandroid:id/programCard"]
${DRSignUpCheckbox}     ${xPathPrefix}android.widget.CheckBox[@resource-id="com.rheem.econetconsumerandroid:id/cbAllow"]
${DREnergySavings}      ${xPathPrefix}*[@text="Energy & Savings"]
${DRContinueButton}     ${xPathPrefix}*[@text="Continue"]
${DRCompleteButton}     ${xPathPrefix}*[@text="Complete"]
${DRIAgree}             ${xPathPrefix}*[@text="I Agree"]
${DRCloseActionImage}   ${xPathPrefix}android.widget.ImageView[@resource-id="com.rheem.econetconsumerandroid:id/closeProgram"]
${DRMyProgramsList}     ${xPathPrefix}androidx.recyclerview.widget.RecyclerView[@resource-id="com.rheem.econetconsumerandroid:id/myProgramsList"]
${DRIcon}               ${xPathPrefix}android.widget.ImageView[@resource-id="com.rheem.econetconsumerandroid:id/whEnergySavings"]

