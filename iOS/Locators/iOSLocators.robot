*** Variables ***

${imageLogo}                                applogo
${sign_in_link}                             //XCUIElementTypeButton[@name="Sign In"]
${btnDiagnoseMode}                          //XCUIElementTypeButton[@name="Diagnostic Mode"]
${btnAllow}                                 //XCUIElementTypeButton[@name="Allow"]
${emailTextbox}                             SignInEmail
${passwordTextbox}                          SignInPassword
${sign_in_button}                           SignInBtn
${btnCreateAccount}                         //XCUIElementTypeButton[@name="Create Account"]
${btnForgotPassword}                        //XCUIElementTypeStaticText[@name="Forgot Password?"]
${txtnameTextField}                         nameTextField
${txtBxFirstName}                           firstNameTextField
${txtBxLastName}                            lastNameTextField
${txtBxEmailAddress}                        emailTextField
${txtBxPhoneNumber}                         phoneTextField
${txtBxPassword}                            passwordTextField
${txtBxCnfrmPasswrd}                        confirmPasswordTextField
${agreeCheckBox}                            termsCheckButton
${emailAlertCheckbox}                       emailCheckButton
${messageCheckBox}                          textMessagesCheckButton
${marketEmailCheckBox}                      marketingCheckButton
${btnSubmit}                                btnSubmit
${btnSubmitForgotPass}                      //XCUIElementTypeStaticText[@name="Submit"]
${btnAddress}                               addressTextField
${btnCity}                                  cityTextField
${btnState}                                 stateTextField
${btnZipCode}                               postalCode(nil, false)TextField
${btnConnect}                               //XCUIElementTypeButton[@name="Connect"]
${txtBxForgotEmail}                         Email
${btnResetPassword}                         btnResetPassword
${txtBxPasswordChange}                      passwordTextField
${txtBxCnfrmPassChange}                     confirmPasswordTextField

${iconNotification}                         validateBell
${alertIcon}                                //XCUIElementTypeCell[1]/XCUIElementTypeStaticText
${btnForwardContractor}                     //XCUIElementTypeButton[@name="Forward to Contractor"]
${btnContractor}                            Contractor
${btnDeleteDraft}                           contractorBin
${btnCancelContractor}                      Cancel
${clearAll}                                 clear all
${clearAlerts}                              Clear All Alerts
${EditContractor}                           contractorEdit
${chkBox1Notification}                      productAlertEmailsSwitcher
${chkBox2Notification}                      productAlertTextMessagesSwitcher
${chkBox3Notification}                      specialOfferEmailsSwitcher
${chkBox4Notification}                      specialOfferTextMessagesSwitcher
${txtBxNumberNotification}                  txtNumber
${txtBxValidationPrePart}                   //XCUIElementTypeCollectionView/XCUIElementTypeCell[
${txtBxValidationPostPart}                  ]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTextField
${btnValidate}                              btnResetPassword
${keyboardDoneButton}                       Done
${guidedTour}                               Guided Tour
${noThanks}                                 No, thanks
${txtUserGuide}                             User_Guide
${touchOrFaceId}                            Enable TouchID/FaceID
${notNowButton}                             //XCUIElementTypeButton[@name="Not Now"]
${equipmentCard}                            thermostatCardCurrentValueIdentifier
${currentTemp}                              //XCUIElementTypeStaticText[@name="currentValueIdentifier"]
${tempBubble}                               firstCircleIndicator
${tempBubblePrePart}                        //XCUIElementTypeImage[@name="
${tempBubblePostPart}                       "]
${imgBubble}                                firstCircleIndicator
${awayMode}                                 btnHomeAway
${awayText}                                 homeAwayButtonIdentifier
${changeLocationButton}                     down arrow
${locationNamePrePart}                      //XCUIElementTypeStaticText[@name="
${locationNamePostPart}                     "]
${modeNameDetailScreenPrePart}              //XCUIElementTypeButton[@name="
${modeNameDetailScreenPostPart}             "]
${txtIamAway}                               txtHomeAway
${btnCancel}                                Cancel
${tempDashBoard}                            waterheaterCardCurrentValueIdentifier
${tempEccDashBoard}                         tempValue
${thermostatCardCurrentValueIdentifier}     thermostatCardCurrentValueIdentifier
${modeDashBoard}                            waterheaterCardModeValueIdentifier
${coolTempDashBoard}                        thermostatCardCoolValueIdentifier
${heatTempDashBoard}                        thermostatCardHeatValueIdentifier
${speedFanDashBoard}                        thermostatCardFanValueIdentifier
${modeEccDashBard}                          thermostatCardModeValueIdentifier
${thermostatFanSpeedButton}                 thermostatFanSpeedButton
${waterheaterCardStatusValueIdentifier}     waterheaterCardStatusValueIdentifier
${modeTypeElectric}                         mode1
${fanSpeedVerificationText}                 Set Continuous Fan Speed
${humidity}                                 Humidity
${postHumidity}                             "]
${humidityYes}                              //XCUIElementTypeButton[@name="Yes"]
${humidityValue}                            sliderValue
${coolTempButton}                           coolingButtonsView
${heatTempButton}                           heatingButtonsView
${currentModeScheduling}                    //XCUIElementTypeOther[5]/XCUIElementTypeOther/XCUIElementTypeButton
${currentModeOFF}                           //XCUIElementTypeOther[4]/XCUIElementTypeOther/XCUIElementTypeButton
${hpwhMode}                                 //XCUIElementTypeOther[5]/XCUIElementTypeOther
${hpwhMode2}                                //XCUIElementTypeOther[4]/XCUIElementTypeOther
${eccMode}                                  thermostatModeButton
${eccOffMode}                               //XCUIElementTypeOther[5]/XCUIElementTypeOther
${disabled}                                 //XCUIElementTypeButton[@name="Disabled"]
${enable}                                   //XCUIElementTypeButton[@name="Enabled"]
${esElectric}                               //XCUIElementTypeButton[@name="Energy Saver"]
${pfElectric}                               //XCUIElementTypeButton[@name="Performance"]
${eleVisiblePre}                            //*[@name='
${eleVisiblePost}                           ' and @visible='true']
${Network}                                  Network
${offMode}                                  OFF
${energySaverHPWHMode}                      ENERGY SAVING
${heatPumpOnlyMode}                         HEAT PUMP ONLY
${highDemandMode}                           HIGH DEMAND
${electricMode}                             ELECTRIC MODE
${energySaverHPWHG5}                        Energy Saver
${offModeHPWHG5}                            Off
${heatPumpModeHPWHG5}                       Heat Pump
${highDemandModeHPEHG5}                     High Demand
${electricModeHPEHG5}                       Electric
${vacationModeHPWHG5}                       Vacation
${performanceMode}                          Performance
${energySavingMode}                         Energy Saver
${scheduleButton}                           Schedule
${btnSetting}                               ic device settings
${btnWifi}                                  ic wifi signal high
${deviceHealth}                             Health
${health}                                   Health
${compressorHealth}                         Compressor Health
${compressorHealthText}                     Compressor life is normal
${elementHealth}                            Element Health
${elementHealthText}                        Element operating normally
${ProductSetting}                           Settings
${backButtonDetailPage}                     backButtonIdentifier
${cautionMessage}                           CAUTION HOT WATER. Contact may cause serious burns to skin
${usageReport}                              Usage
${EnableMode}                               Enabled
${DisableMode}                              Disabled
${DisableModeTriton}                        Disabled    1
${EnableModeTriton}                         Enabled    1
${fanAutoMode}                              Auto
${fanLowMode}                               Low
${fanMed.LoMode}                            Med.Lo
${fanMediumMode}                            Medium
${fanMedHiMode}                             Med.Hi
${fanHighMode}                              High
${modeHeatECC}                              Heating
${modeCoolECC}                              Cooling
${modeAutoECC}                              Auto
${modeFanECC}                               Fan Only
${modeOff}                                  Off
${modeEmergency}                            Emergency Heat
${msgSchedule}                              //XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[2]/XCUIElementTypeStaticText
${msgScheduleWaterHeater}                   //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeStaticText
${tempOverlay}                              Adjust temperature
${fanSppedPlus}                             fanPlus
${fanSpeedMinus}                            fanMinus
${usageText}                                usageText
${daily}                                    Daily
${weekly}                                   //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]/XCUIElementTypeSegmentedControl[3]/XCUIElementTypeButton[2]
${monthly}                                  //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]/XCUIElementTypeSegmentedControl[3]/XCUIElementTypeButton[3]
${yearly}                                   Yearly
${viewCheckBox}                             btnCheckBox1
${currentDataChartDay}                      //XCUIElementTypeOther[@name=". 2 datasets. Previous Day, "]
${historicDataChartDay}                     . 2 datasets. Previous Day, Current Day
${currentDataChartWeek}                     . 2 datasets. Previous Week
${historicDataChartWeek}                    . 2 datasets. Previous Week, Current Week
${currentDataChartMonth}                    . 2 datasets. Previous Month
${btnCheckBoxUsage}                         //XCUIElementTypeButton[@name="btnCheckBox1"]
${historicDataChartMonth}                   . 2 datasets. Previous Month, Current Month
${currentDataChartYear}                     //XCUIElementTypeOther[@name=". 2 datasets. Previous Year, "]
${historicDataChartYear}                    . 2 datasets. Previous Year, Current Year
${fullscreenOn}                             fullscreen on
${pageTitle}                                Away Settings
${selectLocationPrePart}                    //XCUIElementTypeStaticText[@name="
${selectLocationPostPart}                   "]/following-sibling::XCUIElementTypeButton[@name="accordion collasped"]
${locationAwayPrePart}                      //XCUIElementTypeOther[@name="
${locationAwayPostPart}                     "]/XCUIElementTypeButton[@name="accordion collasped"]
${selectLocation}                           //XCUIElementTypeButton[@name="accordion collasped"]
${selectEquipment}                          //XCUIElementTypeCell/XCUIElementTypeOther[3]
${buttonProduct1}                           //XCUIElementTypeCell[1]/XCUIElementTypeOther[3]
${buttonProduct2}                           //XCUIElementTypeCell[2]/XCUIElementTypeOther[3]
${ValidateButton}                           //XCUIElementTypeButton[@name="Validate"]
${saveButton1}                              //XCUIElementTypeButton[@name="Save"]
${saveButton}                               Save
${saveAway}                                 Done
${doneAway}                                 //XCUIElementTypeButton[@name="btnDone"]
${okButton}                                 Ok
${okButtonAway}                             Ok
${backButton}                               back arrow
${awayLogo}                                 //XCUIElementTypeButton[@name="nest event"]
${btnMenu}                                  //XCUIElementTypeButton[@name="menu"]
${txtLocationSetting}                       LOCATION SETTINGS
${txtAwaySettings}                          Away Settings
${txtLocationProducts}                      Locations & Products
${txtManageZoneNames}                       Zone Settings
${txtAskAlexa}                              Ask Alexa
${txtContacts}                              Contacts
${txtFAQ}                                   FAQ
${txtImAway}                                I'm Away
${txtGeneralSetting}                        General
${txtLogout}                                Sign Out
${txtAccount}                               Profile
${txtNotification}                          Notifications
${txtScheduleAway}                          Scheduled Away/Vacation
${txtAccountSharing}                        Account Sharing
${privacyNotice}                            Privacy Notice
${btnChangePhone}                           Phone Number
${btnChangePassword}                        Password
${txtBxNewNumber}                           phoneTextField
${txtBxConfirmNumber}                       txtBxConfirmNumber
${iconEmail}                                EmailIcon
${iconName}                                 ic_name
${iconPhone}                                PhoneIcon
${btnSavePhoneChanges}                      //XCUIElementTypeButton[@name="Save"]
${btnChangeName}                            Name
${txtNameFirst}                             firstNameTextField
${txtNameSecond}                            lastNameTextField
${btnScheduleEvent}                         Scheduled Events
${btnStartDate}                             //XCUIElementTypeStaticText[@name="Set Date"][1]
${btnEndDate}                               //XCUIElementTypeStaticText[@name="Set Date"]
${btnForwardArrow}                          forward arrow
${selectLocationPrePart}                    //XCUIElementTypeStaticText[@name="
${selectLocPostPartScheduleAway}            "]/following-sibling:://XCUIElementTypeButton[@name="forward arrow"]
${btnSaveScheduleAway}                      Save
${btnEditScheduleEvent}                     btnEdit
${txtSchedleEvent}                          scheduleCalendar
${forwardArrowScheduleEvent}                forward blue arraow
${iconEditManageZone}                       //XCUIElementTypeButton[@name="edit pencil icon"]
${txtBxZone}                                zoneNameTextField
${btnExpand}                                //XCUIElementTypeButton[@name="accordion collasped"]
${btnLaunchAlexa}                           //XCUIElementTypeButton[@name="Launch Alexa App"]
${iconNotification}                         //XCUIElementTypeButton[@name="notification icon"]
${alertIcon}                                //XCUIElementTypeCell[1]/XCUIElementTypeStaticText
${btnForwardContractor}                     //XCUIElementTypeButton[@name="Forward to Contractor"]
${btnContractor}                            Contractor
${btnDeleteDraft}                           //XCUIElementTypeButton[@name="Delete Draft"]
${btnCancelContractor}                      Cancel
${success}                                  Success
${noAlertText}                              There are currently no alerts.
${logoQuestions}                            //XCUIElementTypeStaticText[@name="Frequently Asked Questions"]
${currentPassword}                          currentPasswordTextField
${passwordChangePassword}                   newPasswordTextField
${confirmPassword}                          confirmNewPasswordTextField
${txtBxForgotPassword}                      txtForgotEmail
${btnAddNewContractor}                      Add Contractor
${btnWaterHeaterPrePart}                    //XCUIElementTypeButton[@name="
${txtBxEmailContractor}                     //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeTextField
${iconEdit}                                 contractorEdit
${btnSavechanges}                           //XCUIElementTypeButton[@name="Save"]
${btnYes}                                   Yes
${btnSave}                                  //XCUIElementTypeButton[@name="Save"]
${btnAddNewLocation}                        Add New Location
${btnAddProductPrePart}                     btnAddProduct
${MyCurrentLocation}                        //XCUIElementTypeStaticText[@name="Use My Current Location"]
${txtBxZipCode}                             //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[3]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeTextField
${txtcountry}                               //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeScrollView/XCUIElementTypeOther[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther[1]/XCUIElementTypeTextField
${btnNext}                                  btnNext
${btnContinue}                              btnContinue
${txtBxLocation}                            //XCUIElementTypeOther[1]/XCUIElementTypeTextField
${txtBxProduct}                             //XCUIElementTypeCell/XCUIElementTypeTextField
${deviceRunningStatus}                      //XCUIElementTypeTable/XCUIElementTypeCell/XCUIElementTypeStaticText
${product0}                                 //XCUIElementTypeImage[@name="Product_0"]
${setpointIncreaseButton}                   increaseButton
${setpointDecreaseButton}                   decreaseButton
${historicalDataSwitcher}                   historicalDataSwitcher
${homeWifiConn}                             Home WiFi Connections
${btnAdd}                                   Add Manually
${txtBxAddSSID}                             wifiNameTextField
${btnSecurity}                              Security type
${ssidPassword}                             passwordTextField
${txtBxSSID}                                txtBxSSID
${econetWifiConn}                           //XCUIElementTypeStaticText[@name="EcoNet WiFi Connections"]
${coolingIncrease}                          coolingPlusButton
${coolingDecrease}                          coolingMinusButton
${heatingIncrease}                          heatingPlusButton
${heatingDecrease}                          heatingMinusButton
${heatTempValSchedule}                      heatTemp
${coolTempValSchedule}                      coolTemp
${sunday}                                   SUN
${monday}                                   MON
${tuesday}                                  TUE
${wednesday}                                WED
${thursday}                                 THU
${friday}                                   FRI
${saturday}                                 SAT
${followScheduleMsg}                        Following Schedule
${modeSchedule}                             //XCUIElementTypeStaticText[@name="modeSchedule"]
${modeTextAway}                             //XCUIElementTypeCell/XCUIElementTypeStaticText[3]
${mode_ForwardArrow}                        mode_ForwardArrow
${away_ForwardMode}                         rightButton
${mode_backwardArrow}                       mode_backwardArrow
${txtNotNow}                                Not Now
${txtSavePassword}                          //XCUIElementTypeButton[@name="Save Password"]
${txtUpdatePassword}                        Update Password
${saveSchedule}                             btnSave
${timeSchedule}                             Copy
${timeSlot}                                 timeSlot
${scheduleToggle}                           scheduleToggle
${copyButton}                               Copy
${timeSlot}                                 timeSlot
${hourPicker}                               //XCUIElementTypePickerWheel[1]
${minutePicker}                             //XCUIElementTypePickerWheel[2]
${amPmPicker}                               //XCUIElementTypePickerWheel[3]
${doneTimePicker}                           btnDone
${down_arrow}                               arrow0
${row1}                                     //XCUIElementTypeTable/XCUIElementTypeCell[1]/XCUIElementTypeStaticText
${row2}                                     //XCUIElementTypeTable/XCUIElementTypeCell[2]/XCUIElementTypeStaticText
${row3}                                     //XCUIElementTypeTable/XCUIElementTypeCell[3]/XCUIElementTypeStaticText
${row4}                                     //XCUIElementTypeTable/XCUIElementTypeCell[4]/XCUIElementTypeStaticText
${btnDayOff}                                //XCUIElementTypeApplication[@name="RheemEcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther
${down_arrow1}                              arrow1
${btnOccupieOnOffAttr}                      slotSwitcherIdentifier
${btnOccupieOnOff}                          //XCUIElementTypeOther[@name="switchValue"]
${scheduleArrow}                            arrow
${scheduleSlider}                           //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[2]
${homeaway}                                 homeAwayButtonIdentifier
${savebutton01}                             //XCUIElementTypeButton[@name="btnSave"]
${txtHeaterList}                            //XCUIElementTypeTable/XCUIElementTypeCell
${txtHeaterPrePart}                         //XCUIElementTypeTable/XCUIElementTypeCell[
${txtHeaterPostPart}                        ]/XCUIElementTypeStaticText
${awayGeoFencing}                           Geofencing
${geoFancingtxtOn/Off}                      //XCUIElementTypeStaticText[@name="Off / On"]
${geoFenceButton}                           GeofencingSwitcher
${geoTxtLocation}                           //XCUIElementTypeStaticText[@name="Location:"]
${geoLocationName}                          GeoFence_LocationName
${geoUnitName}                              Distance Unit
${distanceGeoUnit}                          //XCUIElementTypeStaticText[@name="Distance Unit:"]
${geoMapPin}                                //XCUIElementTypeOther[@name="Map pin"]
${geoSearchfield}                           //XCUIElementTypeSearchField
${kilometers}                               Kilometers
${miles}                                    Miles
${cancel}                                   Cancel
${geoFenceRadius}                           GeoFence_Radius
${awaySwitch}                               waterheaterAwaySwitcherIdentifier
${awaySwitch1}                              switchValue_1
${day_Tuesday}                              Tuesday
${day_Wednesday}                            Wednesday
${day_Thursday}                             Thursday
${day_Friday}                               Friday
${day_Saturday}                             Saturday
${day_Sunday}                               Sunday
${day_Monday}                               Monday
${save_Copy_screen}                         //XCUIElementTypeStaticText[@name="Save"]
${btnWaterShuttOff}                         //XCUIElementTypeOther[@name="@VALVE"]
${textShutOff}                              //XCUIElementTypeStaticText[@name="Shutoff"]
${buttonAlert}                              //XCUIElementTypeStaticText[@name="Alert"]
${buttonYES}                                Yes
${buttonNo}                                 No
${heatBubble}                               firstCircleIndicator
${coolBubble}                               secondCircleIndicator
${modeTempBubble}                           firstCircleIndicator
${masterControl}                            //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeCollectionView/XCUIElementTypeCell[1]/XCUIElementTypeOther/XCUIElementTypeOther
${zoneControl}                              //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeCollectionView/XCUIElementTypeCell[3]/XCUIElementTypeOther/XCUIElementTypeOther
${zoneControl2}                             //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeCollectionView/XCUIElementTypeCell[3]/XCUIElementTypeOther/XCUIElementTypeOther
${txtEcoNetCenter}                          //XCUIElementTypeStaticText[@name="EcoNet Control Center"]
${txtModeChange}                            //XCUIElementTypeStaticText[@name="Change Mode"]
${btnResume}                                //XCUIElementTypeStaticText[@name="Resume"][1]
${setPointButton}                           Stepper_Button
${setPointSlider}                           Slider_Button
${setpointIncreaseButton}                   heatPlus
${setpointDecreaseButton}                   heatMinus
${tempHeater}                               heatTemp
${coolSetPointIncreaseButton}               coolPlus
${coolSetPointDecreaseButton}               coolMinus
${coolTempHeater}                           coolTemp
${dehumidification}                         sliderValue
${buttonNo}                                 button0
${buttonYes}                                button1
${buttonConfirm}                            done
${buttonCancel}                             close
${energySavingText}                         This Equipment should be set to ENERGY SAVING Mode for maximum efficiency
${enableTab}                                //XCUIElementTypeButton[@name="ENABLE"]
${energySaving}                             //XCUIElementTypeStaticText[@name="ENERGY SAVING"]
${valveMode}                                modeSchedule
${valveForward}                             mode_ForwardArrow
${recircMode}                               modeSchedule
${recircForward}                            mode_ForwardArrow
${alarmOnly}                                @LEAKACTION_5
${disableWH}                                @LEAKACTION_6
${modebackbuttonidentifier}                 modalBackButtonIdentifier
${slotSwitcherIdentifier}                   slotSwitcherIdentifier
${HvacScheduleCoolTemp}                     //XCUIElementTypeOther[@name="secondCircleIndicator"][1]
${HvacScheduleHeatTemp}                     //XCUIElementTypeOther[@name="firstCircleIndicator"][1]
${rightarrow}                               right arrow
${AddProductButton}                         //XCUIElementTypeButton[@name="btnAddProd"][1]
${DashboardLocationIcon}                    dashboard_location_icon
${BackButtonic}                             ic back
${scheduleoverriddentext}                   //XCUIElementTypeStaticText[@name="ScheduleInfoLabel"][1]
${GoToMail}                                 Go To Mail
${ApplyMail}                                Apple Mail
${SubmitButtonXpath}                        //XCUIElementTypeButton[@name="Submit"]
${validatecode}                             codeTextField
${waterHeaterCheckbox}                      //XCUIElementTypeButton[@name="checkbox"][1]
${HVACCheckbox}                             //XCUIElementTypeButton[@name="checkbox"][2]
${waterHeaterCardStateValueDashboard}       waterheaterCardStateValueIdentifier
${waterHeaterModeButton}                    waterHeaterModeButton
${currentTempCenter}                        //XCUIElementTypeStaticText[@name="currentTemp"]
${DailyHistory}                             . 2 datasets. Previous Day, Current Day
${DecreaseButton}                           //XCUIElementTypeButton[@name="decreaseButton"][1]
${IncreaseButton}                           //XCUIElementTypeButton[@name="increaseButton"][1]
${HPWH_Notification}                        //XCUIElementTypeNavigationBar[@name="Heat Pump Water Heater Gen 4"]
${buttons_type}                             buttons type
${slider_type}                              slider type
${currentTemp1}                             currentTemp
${txtGeofencing}                            //XCUIElementTypeStaticText[@name="Geofencing"]
${schedule_firstrow_time}                   time0
${schedule_secondrow_time}                  time1
${schedule_thirdrow_time}                   time2
${schedule_fourthrow_time}                  time3
${heatingPlusButton}                        //XCUIElementTypeButton[@name="heatingPlusButton"][1]
${waterHeaterStateButton}                   waterHeaterStateButton
${txtAllowmsg}                              Allow While Using App
${OTPScreen}                                codeTextField
${errMsgPhnNumberValid}                     Phone number must have valid digits.
${FirstZoneSelection}                       //XCUIElementTypeImage[@name="RightZoning"][1]
${RightZoning}                              RightZoning
${Contractor5thList}                        //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeTable/XCUIElementTypeCell[5]
${HVACContractorSelect}                     //XCUIElementTypeButton[@name="redCheckBox"][2]
${txtSubmitButton}                          //XCUIElementTypeStaticText[@name="Submit"]
${ButtonResetPassword}                      //XCUIElementTypeButton[@name="Reset Password"]
${GeoFencingSlider}                         //XCUIElementTypeApplication[@name="EcoNet"]/XCUIElementTypeWindow[1]/XCUIElementTypeOther/XCUIElementTypeOther[2]/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther/XCUIElementTypeOther[3]/XCUIElementTypeSlider
${errMsgConnectionInUser}                   //XCUIElementTypeStaticText[@name="Connection name is in use"]
${devicenotifications}                      device notification
${usageIncrease}                            usageIncrease
${units of energy}                          units of energy
${Historicaldatarepo}                       Historical data
${coolingplusbutton}                        //XCUIElementTypeButton[@name="coolingPlusButton"][1]


####  DR Features ######
${EnergySavings}                            Energy & Savings
${GreebBanner}                              AlertView
${txtEnergySavings}                         There are now active energy savings programs in your area!
${ClearAlerts}                              //XCUIElementTypeStaticText[@name="Clear Alert"]
${btnLearnMore}                             //XCUIElementTypeButton[@name="Click To Learn More"]
${MsgGreenBanner}                           There are now active energy savings programs in
${tabExplore}                               Explore
${tabMyPrograms}                            My Programs
${txtforNoPrograms}                         Energy Savings Programs are currently unavailable in your area or your device is not supported.
${CrossGreenBanner}                         //XCUIElementTypeButton[@name=" "][2]
${emailCheckButton}                         //XCUIElementTypeOther[@name="emailCheckButton"]/XCUIElementTypeImage
${ContinueButtom}                           //XCUIElementTypeButton[@name="createAccountButton"]
${CancelPartnerCross}                       //XCUIElementTypeButton[@name=" "]
${CancelButton}                             //XCUIElementTypeButton[@name="createAccountButton"][1]
${IAgreeButton}                             //XCUIElementTypeButton[@name="createAccountButton"][2]


${DRLocationSelection}     locationSelectionIdentifier
${DRProgramCard}           exploreProgramDetailsIdentifier
${DRSignUpCheckbox}        accessCheckButtonIdentifier
${DREnergySavings}         Energy & Savings
${DRContinueButton}        continueButton
${DRCompleteButton}        completeProgramButton
${DRIAgree}                termsAndConditionIdentifier
${DRCloseActionImage}      programCloseIdentifier
${DRIcon}                  es energy
${DRMyPrograms}            myProgramExploreIdentifier
${DRCancelTermsandCondition}    cancelTermsConditionButton
${DROutOfEvent}            //XCUIElementTypeButton[@name="Opt Out Of Event"]
${DRClearAlert}            //XCUIElementTypeButton[@name="Clear Alert"]
${DRSignUpboxButton}       programSignUpIdentifier
${DRprogramConfirmationContentID}    //XCUIElementTypeStaticText[@name="programConfirmationContentID"][1]
${DRprogramConfirmationContentID2}    //XCUIElementTypeStaticText[@name="programConfirmationContentID"][2]
${DRaccountActionRequired}    accountActionRequired

# Locator issue will be resolved once the QA Team received the build from the QA side to recommended for ther QA Side are needed for the Recommenfef for the realised rthat
# QA Team can continue testing on the base side from the received the QA Team received the buils from QA side to recommende dto QA side top resove QA Tickts for
# Can continue testing on the realsi for tjhe recommendation for the realisarion for the    the QA Team can needed for the system for the Stystem requiremnenrts
# QA Can continue on rht etesting based on the requirements fo rthe realisation for the reuired test based on the recommenation.
# Testing will be done ce the QA Team are requyired for the recommended situaation for the required solution for the required for
# Testing will be done once the qa eam realised the issues from thre required doxunments from the recommenfariton for QA Team are required for the System,