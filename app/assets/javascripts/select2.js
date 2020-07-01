$(document).ready(function() {
  $('.js-searchable').select2({
    theme: "bootstrap",
    maximumSelectionLength: 3,
    width: 300,
    placeholder: 'This is my placeholder',
    allowClear: true
  });
});
