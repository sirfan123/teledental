# TeleDental
TeleDental is a communication app between patient and dentist streamlining the communication and checkup process to be fully online.

## Steps to recreate:

- Clone repo
- Assuming you have flutter installed and sdk(Im assuming whoever is grading this has it)
    - Run flutter pub get
    - Run flutter create . in root dir
        - This will setup the flutter project base template but lib will have all of our apps code
- Open Xcode simulator app(I tested on Iphone 15 pro max but shouldnt matter)
    - Run main.dart in debug mode
        - If this is first time it might take a little longer

## Key tasks

- (MORE THAN HALF DONE)Appointment Scheduling: Patients can schedule, modify, or cancel dental appointments, while professionals can manage their availability.
    - Dummy appointments show up on the dentist home page if you click a date on the calender
    - From the patient portal you can click a date on the calender and schedule an appointment time however the data isnt stored properly yet, you cant see this update on dentist portal just yet

- (DONE)Treatment History Tracking: Users can access past treatments with detailed records of procedures, and medications.
    - If you go to the patient portal and history you can see the dummy appointments we loaded in the initial json here

- (MORE THAN HALF DONE)Reminders and Notifications: Automated reminders for upcoming appointments, medication, and hygiene tips.
    - We have prepopulated json data filling the reminder pages for respective portals however getting actual push notifications to appear on the simulator is something we are still working on

- (DONE)Patient-Dentist Communication: A messaging system that allows patients to communicate directly with their dental professionals. 
    - From the dentist or patient messages portal if you send a message you will see it on the other portal
        - Patient portal you send from the bottom of the page and can click one of the messages above to see a response
        - From dentist page just click one of the messages and an input box to respond pops up

## Design changes

- The main change we have is viewmodels, previously we mapped each model to a respective viewmodel that then mapped to two different views. However since each viewmodel has its own respective logic this gets long and hard to track quickly. Our solution was to map each model to two seperate viewmodels now(EX: doctor_treatment_view_model and patient_treatment_view_model). Much easier to track these viewmodels and use with the associated files now. 
    