(function ($) {
 $.fn.railsSortable = function (options) {
 options = options || {};
 var settings = $.extend({}, options);
 
 settings.update = function (event, ui) {
 if (typeof options.update === 'function') {
 options.update(event, ui);
 }
 
 var tableRows = $(this).find("tr");
 if (tableRows && tableRows.length > 0) {
 var ids = [];
 Array.from(tableRows).map(r => {
 var id = $(r).data("id");
 console.log(id);
 ids.push(id);
 });
 
 $.ajax({
 type: 'POST',
 url: '/sortable/reorder',
 dataType: 'json',
 contentType: 'application/json',
 data: JSON.stringify({
 rails_sortable: $(this).sortable('toArray'),
 test_cases: ids,
 }),
 });
 
 
 }
 };
 
 this.sortable(settings);
 };
})(jQuery);