//var ready = function() {
//$(document).ready(function() {
jQuery.fn.watchAvatarType = function() {
  var $el = $(this); // our element

//	console.log("element = " + $el);
//	initAvatarFormFields();
  $("input[name='user[avatar_type]']").change(avatarTypeValueChanged);

  function avatarTypeValueChanged() {
  	console.log("In avatarTypeValueChange. value = " + $(this).val());
  	updateAvatarFormFields($(this));
  };
  function initAvatarFormFields(el) {
  	console.log("** In initAvatarFormFields **");
  	//obj = $("input[name='user[avatar_type]']");
  	console.log("** el = " + el);
  	updateAvatarFormFields(el);
  };

  function updateAvatarFormFields(ref) {
  	radioValue = ref.filter(':checked').val();
  	console.log("in updateAvatarFromFields. value = " + radioValue);

  	if (radioValue === "Gravatar") {
    	hideNoneField();
    	hideUploadField();
    	showGravatarField();
    }
    else if (radioValue === "Upload") {
    	hideNoneField();
    	hideGravatarField();
    	showUloadField();
    }
    else {
    	//If equal none of undefined
    	hideGravatarField();
    	hideUploadField();
    	showNoneField();
    }
  };

  function hideGravatarField() {
  	$("#user-avatar-gravatar-field").hide();
  }
  function showGravatarField() {
  	$("#user-avatar-gravatar-field").show();
  }
  function hideUploadField() {
  	$("#user-avatar-upload-field").hide();
  }
  function showUloadField() {
  	$("#user-avatar-upload-field").show();
  }
  function hideNoneField() {
  	$("#user-avatar-none-field").hide();
  }
  function showNoneField() {
  	$("#user-avatar-none-field").show();
  }

  initAvatarFormFields($el);
  return $el;
};
//$(document).ready(ready);
//$(document).on('page:load', ready);