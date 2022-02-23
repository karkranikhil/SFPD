import { LightningElement, track, wire, api } from 'lwc';
import { loadScript, loadStyle } from 'lightning/platformResourceLoader';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import FullCalendarJS from '@salesforce/resourceUrl/FullCalendarJS';
import { NavigationMixin } from 'lightning/navigation';
import { refreshApex } from '@salesforce/apex';
import TIME_ZONE from '@salesforce/i18n/timeZone';
import MomentTimezone from '@salesforce/resourceUrl/MomentTimezone';
import LOCALE from '@salesforce/i18n/locale';
import fetchEvents1 from '@salesforce/apex/FullCalendarController.fetchEvents';
import updateContact from '@salesforce/apex/ContactDashboardController.updateContact';
import updateTask from '@salesforce/apex/ContactExamController.updateTask';
import updateBgTask from '@salesforce/apex/ContactDocController.updateTask';
import fetchApplicationId from '@salesforce/apex/FullCalendarController.fetchApplicationId';





const timeZone = TIME_ZONE;
export default class Fullcalendar extends NavigationMixin(LightningElement) {
    fullCalendarJsInitialised = false;
    @track url_param = 'test';
    // @api isPopup = false;
    @track events = [];
    @track isModalOpen = false;
    @track sendDate;
    @track modalData = {};
    @track taskIdURL;
    @track applicationId;
    isWritten = false;
    get bgTask() {
        if (this.url_param === 'Written' || this.url_param === 'Physical' || this.url_param === 'Interview') {
            return false;
        }
        return true;
    }
    closeModal() {
        // to close modal set isModalOpen tarck value as false
        this.isModalOpen = false;
    }
    submitDetails() {
        // to close modal set isModalOpen tarck value as false
        //Add your code to call apex method or do some processing
        this.isModalOpen = false;
    }

    connectedCallback() {
        var url = new URL(window.location.href);
        this.url_param = url.searchParams.get("item");
        console.log('Url parms :>> ', this.url_param);
        var taskId = url.searchParams.get("regId");
        this.taskIdURL = url.searchParams.get("regId");
        console.log('Task Id :>> ', taskId);
        console.log('===== MomentTimezone '+MomentTimezone);
    }
    renderedCallback() {
        // Performs this operation only on first render
        if (this.fullCalendarJsInitialised) {
            return;
        }
        this.fullCalendarJsInitialised = true;
        Promise.all([
             //loadScript(this, MomentTimezone + "/MomentTimezone.js"),
             loadStyle(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.css"),
             loadScript(this, FullCalendarJS + "/FullCalendarJS/jquery.min.js"),
             loadScript(this, FullCalendarJS + "/FullCalendarJS/moment.min.js"),
             loadScript(this, FullCalendarJS + "/FullCalendarJS/fullcalendar.min.js")
        ])
            .then(() => {
                //initialize the full calendar
                console.log('initialiseFullCalendarJs');
                //setTimeout(function(){ this.renderfetchEvents1function(); }, 3000);
                this.renderfetchEvents1function();
                this.initialiseFullCalendarJs();

            })
            .catch((ex) => {
                console.log('error in promise ' + ex);
                console.error({
                    message: "Error occured on FullCalendarJS",
                    ex,
                });
            }
            )
    }
    initialiseFullCalendarJs() {
        const ele = this.template.querySelector("div.fullcalendarjs");
        $(ele).fullCalendar({
            header: {
                left: "prev,next today",
                center: "title",
                right: "year,month,agendaWeek,agendaDay",
            },
            scrollTime: '06:00:00',
            aspectRatio: 2,
            //timezone : timeZone,

            defaultDate: new Date(), // default day is today - to show the current date
            defaultView: 'month', //To display the default view - as of now it is set to week view
            navLinks: true, // can click day/week names to navigate views
            selectable: true, //To select the period of time
            eventLimit: false,
            events: this.events,
            eventClick: (calEvent, jsEvent, view) => {
                // alert('calEventTitle ' + calEvent.title + 'calEventstarttime ' + calEvent.start + 'calEventendtime ' + calEvent.end + 'event.id ' + calEvent.id);
                this.isModalOpen = true;
                this.modalData = calEvent;
                //this.modalData.StartDateTime = Date.parse(calEvent.start)
                console.log('Sent to Popup'+calEvent.start);
                //this.sendData = calEvent.start;
                this.sendData = Date.parse(calEvent.start);
                console.log('Event Id',calEvent.id);
                this.eventId = calEvent.id;
            }
            //events: this.events, // all the events that are to be rendered - can be a duplicate statement here

        });

    }
    renderfetchEvents1function() {
        console.log('this.url_param :>> ', this.url_param);
        this.fetchApplicationId();
        fetchEvents1({ itemName: this.url_param })
            .then(data => {
                let events = data.map(event => {
                  /* console.log(moment(event.StartDateTime).format('hh:mm a'));
                   console.log(event.StartDateTime);
                    console.log('New Date '+new Date(event.StartDateTime)); */

                console.log('=====Start '+event.StartDateTime);
                //console.log('======Start Formatted '+moment(event.StartDateTime).utc().format());
             
                console.log('======= End '+event.EndDateTime);
                //console.log('========End Formatted'+moment(event.EndDateTime).tz(timeZone).format());
               
                if(event.Subject =='Written Test'){
                    this.isWritten = true;
                }
                  
                    return {
                        id: event.Id,
                        title: event.Subject,
                        start: (event.StartDateTime),
                        //start: moment(event.StartDateTime).utc().format(),
                        //end: moment(event.EndDateTime).utc().format(),
                        //start: moment(event.StartDateTime).tz(timeZone).format(),
                        end: (event.EndDateTime),
                        allDay: event.IsAllDayEvent
                    };
                });
                this.events = JSON.parse(JSON.stringify(events));
                console.log('this.Events ',JSON.stringify(this.events));
                const ele = this.template.querySelector("div.fullcalendarjs");
                console.log('ele ',ele);
                $(ele).fullCalendar('renderEvents', this.events, true);
            })
            .catch(error => {
                this.error = error;
                console.log('ERRORfetchevents ' + JSON.stringify(this.error));

            })
    }

    fetchApplicationId(){
        console.log('Fetch App Id');
        fetchApplicationId({ taskId: this.taskIdURL})
            .then(result => {
                console.log('##APP ID',result);
                this.applicationId = result;
            })
            .catch(error => {
                console.log('FetchAPP error');
                console.log(error)
            })


    }
    handleClick(event) {
        var url = new URL(window.location.href);
        let taskId = url.searchParams.get("regId");
        console.log('Recieved From Popup'+event.currentTarget.dataset.date);
        console.log('Date Converted From Popup'+new Date(Number(event.currentTarget.dataset.date)));


        let taskDate = new Date(Number(event.currentTarget.dataset.date));
        let time = taskDate.toLocaleTimeString();

        let eventId = event.currentTarget.dataset.id;
         //console.log('toLocaleTimeString '+moment(time).utc().format());
        
        /* console.log('time :>> ',typeof(time));
        console.log(event.currentTarget.dataset.date, taskId, taskDate);
        console.log('bgTask :>> ', this.bgTask);
        console.log('Date Selected :>> ', event.currentTarget.dataset.date);
        console.log('Date Passed :>> ',taskDate);
        console.log('Time Selected :>> ', taskDate.toLocaleTimeString());
        console.log('Time Passed :>> ',taskDate);*/
          
        if (this.bgTask === true) {
            updateBgTask({ taskId: taskId, taskDate: taskDate })
            .then(result => {
                console.log(result);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: 'https://sfmtx-psportal.cs195.force.com/s/view-application?applicationId='+ this.applicationId
                        }
                    });
            })
            .catch(error => {
                console.log(error)
                if (error.body && error.body.message) {
                    this.dispatchEvent(new ShowToastEvent({
                        title: 'Error',
                        message: error.body.message,
                        variant: 'error'
                    }));
                }
            })
        }
        else {
            console.log('IN HERE :>> ');
            updateTask({ taskId: taskId, taskDate: taskDate, testTime: time ,eventId: eventId})
                .then(result => {
                    console.log(result);
                    this[NavigationMixin.Navigate]({
                        type: 'standard__webPage',
                        attributes: {
                            url: 'https://sfmtx-psportal.cs195.force.com/s/view-application?applicationId='+ this.applicationId
                        }
                    });
                })
                .catch(error => {
                    console.log(error)
                    if (error.body && error.body.message) {
                        this.dispatchEvent(new ShowToastEvent({
                            title: 'Error',
                            message: error.body.message,
                            variant: 'error'
                        }));
                    }
                });
        }

        // updateRegister({
        //     testDate: this.sendDate
        // })
        //     .then(data => {
        //         if (data) {
        //             let result = JSON.parse(JSON.stringify(data));
        //             console.log('result :>> ', result);
        //         }
        //     }).catch(error => {
        //         let errorShow = JSON.parse(JSON.stringify(error));
        //         console.log('Error :>> ', errorShow);
        //     });
        // console.log('Go To Application clicked ', event.target.value);
        // let appID = this.applications[event.target.value].applicationId;
        // updateContact({
        //     appId: appID,
        //     appStatus: this.applications[event.target.value].applicationStatus
        // }).then(result => {
        //     console.log('updateContact Result: ', result);
        //     window.open("https://psportal.force.com/s/view-application?applicationId=" + appID, "_self");
        // }).catch(error => {
        //     console.log('updateContact error: ', error);
        // });
        // this[NavigationMixin.GenerateUrl]({
        //     type: 'standard__webPage',
        //     attributes: {
        //         url: '/s/my-dashboard'
        //     }
        // }).then(generatedUrl => {
        //     window.open(generatedUrl,"_self");
        // });
    }
}