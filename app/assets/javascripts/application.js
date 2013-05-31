// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery-ui
//= require jquery_ujs
//= require_tree .

// Flash fade
	$(function() {
	   $('.alert-success').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});
	
	$(function() {
	   $('.alert-error').fadeIn('normal', function() {
	      $(this).delay(3700).fadeOut();
	   });
	});

	// Accordian code	
	// 	$(function() {
	// 		$("#accordion").accordion();
	//	});

// Datepicker code
	$(function() {
		$(".datepicker").datepicker({
			format: 'mm/dd/YYYY'
		});
	});

// Autosubmit the quick registration form on the sections#show view
	$(function() {
		$('#registration_student_id').change(function()
		 {
		     $('#new_registration').submit();
		 });
	});
	

// Autocomplete, source is http://jqueryui.com/autocomplete/
	$(function() {
    	var availableStudents = Student.alphabetical.all;
    		$( "#searchstudent" ).autocomplete({
      source: availableStudents
    	});
  	});

// Autocomplete, source is http://stackoverflow.com/questions/3188157/how-to-set-up-jquery-ui-autocomplete-in-rails
   $(function() {
   	// Below is the name of the textfield that will be autocomplete
   	$( "#select_origin" ).autocomplete({
   	// This shows the min length of characters that must be typed before the autocomplete looks for a match.
   	            minLength: 2,
   	 // This is the source of the autocomplete suggestions. In this case a list of names from the students controller, in JSON format.
   	            source: '<%= students_path(:json) %>',
   	 // This updates the textfield when you move the updown the suggestions list, with your keyboard. In our case it will reflect the same value that you see in the suggestions which is the student.name.
   	            focus: function(event, ui) {
   	                $('#select_origin').val(ui.item.student.name);
   	                return false;
   	            },
   	 // Once a value in the drop down list is selected, do the following:
   	            select: function(event, ui) {
   	 // place the student.name value into the textfield called 'select_origin'...
   	                $('#select_origin').val(ui.item.student.name);
   	 // and place the student.id into the hidden textfield called 'link_origin_id'. 
   	        $('#link_origin_id').val(ui.item.student.id);
   	                return false;
   	            }
   	        })
   	 // The below code is straight from the jQuery example. It formats what data is displayed in the dropdown box, and can be customized.
   	        .data( "autocomplete" )._renderItem = function( ul, item ) {
   	            return $( "<li></li>" )
   	                .data( "item.autocomplete", item )
   	 // For now, just want to show the student.name in the list.
   	                .append( "<a>" + item.student.name + "</a>" )
   	                .appendTo( ul );
   	});
 	});

