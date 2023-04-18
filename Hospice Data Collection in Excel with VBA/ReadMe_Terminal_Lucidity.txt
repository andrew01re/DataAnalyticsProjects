Project Objective: 
Create an offline data collection solution that can be used by nurses with minimal technology fluency to collect non-PII patient data on the terminal lucidity phenomenon 

Background: 
This worksheet is an ongoing project that started at the request of a nursing student working in hospice and palliative care. After reading a couple small-scale studies and her own personal observations, she wanted to further investigate a common phenomenon in dementia patients called "Terminal Lucidity". For context, this term describes when a dementia patient has an unexpected return to mental clarity and memory, often in a short amount of time before death. The student requested a method of collecting several demographic characteristics as well as qualitative and quantitative metrics for assessing the cognitive health of a patient prior to, during, and after the terminal lucidity experience.

Method: 
The "Report" sheet of this macro-enabled excel workbook is the front end to be used by the nurse(s) collecting data. This form includes several methods of data entry including manual text entry, drop down lists, checkboxes, and bubbles. 

When the form is complete, the nurse can click "SUBMIT" to create a record of the form at the current state. All controls are linked to cells in column P. The values in column Q either copy directly from the manual entry cells, copy the resulting index from column P, or use those indexing values to return the text value associated with it listed in the "Options" sheet. When the "SUBMIT" button is pressed, a macro runs to copy the values in column Q and pastes them into a row as a record in the "Data" sheet, additionally including the record number, date, and time that the record was created.

The form can then be cleared by clicking the "Reset Form" button. Default values for each of the controls are listed in Column O. The ResetForm macro linked to this button copies and pastes Column O over Column P, changing the linked controls to their default values. Additional code was added to the macro to clear the manual entry cells (e.g. Age, Notable Lab Results, Diagnoses, etc.).

To view an existing record on the front-end form, there is a drop-down list that includes the record number, date, and time of the record used as an identifier. The "View Existing Record" button runs a macro that searches the "Data" sheet for the selected record, copies the data within the associated row, and pastes it onto Column P of the "Report" sheet, changing the controls to the values of the existing record. The macro also runs a manual copy/paste from the cells of Column P associated with the manual entry cells.

DISCLAIMER: The data included in this version of the workbook are fictitious examples. No real patient data is included.