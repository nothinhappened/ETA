// All these id, class, data-* points are used in time_entries.js 
// in order to faciliate the editing of time_entry descriptions
// class = edit_time_entry_button 								// Used for event delegation
// data-entry-id = day[:task_id]_day[:description_id]  	// used to identify the time_entry this button corresponds to
// id = edit_time_entry_comment_dialog 						// used by bootstrap to identify the modal dialog
// edit_time_entry_comment_text_area 							// the text_area field which records the comments of the time_entries.
// edit_time_entry_comment_entry_id 							// a hidden field which holds a reference to the specifi time_entry in which the modal dialog is open to

// Call when opening the edit description dialog
// The purpose of this function:
// 1. Place the description of the specified time_entry
// 	into the text_area of the modal dialog
// 2. Record a reference (i.e. id) back to the time_entry text area,
//		so that when the user clicks "save" the comment will be recorded
// 	back into the the proper text_area field.
function open_entry_description(e)
{
	var entry_id = $(e.currentTarget).data("entry-id");
	var entry_text_area = $("#" + entry_id);
	$("#edit_time_entry_comment_text_area").val(entry_text_area.val());
	$("#edit_time_entry_comment_entry_id").data("entry-id",entry_id);
}


// Using the reference placed by a call to open_entry_description()
// Record the text entered in the dialog and place it in the 
// specified text_area field.
function save_entry_description()
{
	var entry_id = $("#edit_time_entry_comment_entry_id").data("entry-id");
	var entry_text_area = $("#" + entry_id);

	if( entry_text_area.length ){
		var comment = $("#edit_time_entry_comment_text_area").val();		
		entry_text_area.val(comment);		

		// change the colour of the edit description button if necessary
		// TODO: move this logic to some "onchange" method..
		var color_comment = (comment === "") ? "#999": "#333"
		
		// get the element with id 'entry_id'
		// select every button element preceding the 'entry_id'
		// then select spans elemens with button as the parent
		$("#" + entry_id + " ~ button > span").css("color", color_comment)		
	}else{
		// text-area id does not exist.
		// error reporting?
	}	
}


function changeTimesheetPage(target_date)
{
	// TODO: I don't really like this method of redirecting the page for the new date.
	// ALT 1 : Use a hidden form to submit the required parameters to the page.
	// ALT 2 : Set up some AJAX thing..?
	//window.location = '/time_entries/get_target_week?target_date=' + target_date;  
	
	$("#time_entries_datepicker_form input[type=hidden]").val(target_date);
  	$("#time_entries_datepicker_form").submit();  		
}


// This really should be hooked on an onReady or page:load event
function hook_time_entries_event_handlers(){
	// Attach an event delegate to open the edit_description dialog
	$(".timesheet_table").on("click",".edit_time_entry_button", open_entry_description);


	
	$('#edit_time_entry_comment_dialog')
	.on('shown.bs.modal',function(){
		// Make sure that the text_box in the modal dialog get focus when it is shown.
		$("#edit_time_entry_comment_text_area").focus();		
	})	
	.on('hide.bs.modal',function(){
		// Make sure that the entry descriptions gets saved to the hidden text_area
		// when the modal closes.
		save_entry_description();
	});


	// datepicker
	$('#time_entries_datepicker').datepicker({
		weekStart: 1,
		format: "yyyy-mm-dd"
	})
  	.on('changeDate', function(ev){ 
  		$('#time_entries_datepicker').datepicker('hide');
  		changeTimesheetPage(this.value);  		
    });

}

// HACKS!
// 1. This code gets run for ANY document ready, or 'page:load', therefore
//			even on pages which are not the time_entries pages
// 2. the document.ready function doesn't get fired when changing between tabs.
//		(i.e. going from 'manage users' to 'home'). from what I have read this is 
//		caused by our turbollinks gem... anyway This is the reason why I also hook on
//		the page:load, so that even if 'ready' doesn't get triggered, the hooks are still
//		added.
$(document).ready(function(){	
	hook_time_entries_event_handlers();
})
$(document).on('page:load',function(){	
	hook_time_entries_event_handlers();
})

