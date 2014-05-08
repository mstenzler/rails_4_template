jQuery.fn.selectTimeZone = function() {
  var $el = $(this[0]); // our element
  var offsetFromGMT = String(- new Date('1/1/2009').getTimezoneOffset() / 60); // using 1/1/2009 so we know DST isn't tripping us up
  if (offsetFromGMT[0] != '-') {
    offsetFromGMT = '+' + offsetFromGMT; // if it's not negative, prepend a + 
  }
  if (offsetFromGMT.length < 3) {
    offsetFromGMT = offsetFromGMT.substr(0, 1) + '0' + offsetFromGMT.substr(1); // add a leading zero if we need it
  }
  var regEx = new RegExp(offsetFromGMT); // create a RegExp object with our pattern
  $('option', $el).each(function(index, option) { // loop through all the options in our element
    var $option = $(option); // cache a jQuery object for the option
    if($option.html().match(regEx)) { // check if our regex matches the html(text) inside the option
      $option.attr({selected: 'true'}); // select the option
      return false; // stop the loop—we're all done here
    }
  });
}
