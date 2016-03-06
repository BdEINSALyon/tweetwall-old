/*global jQuery */
/*!
 * FitText.js 1.2
 *
 * Copyright 2011, Dave Rupert http://daverupert.com
 * Released under the WTFPL license
 * http://sam.zoy.org/wtfpl/
 *
 * Date: Thu May 05 14:23:00 2011 -0600
 */

(function( $ ){

    $.fn.fitText = function( kompressor, options ) {

        // Setup options
        var compressor = kompressor || 1,
            settings = $.extend({
                'minFontSize' : Number.NEGATIVE_INFINITY,
                'maxFontSize' : Number.POSITIVE_INFINITY
            }, options);

        return this.each(function(){

            // Store the object
            var $this = $(this)
            var el = this;

            // Resizer() resizes items based on the object width divided by the compressor * 10
            var resizer = function () {
                var elNewFontSize = (parseInt($this.css('font-size').slice(0, -2)) - 1) + 'px';
                $this.css('font-size', elNewFontSize);
                if(el.scrollHeight>el.clientHeight||el.scrollWidth>el.clientWidth) {
                    resizer();
                }
            };

            // Call once to set.
            if(el.scrollHeight>el.clientHeight||el.scrollWidth>el.clientWidth)
                resizer();
            var shouldStopNow = false;
            while(this.scrollHeight<=this.clientHeight && el.scrollWidth <= el.clientWidth && !shouldStopNow){
                var elNewFontSize = (parseInt($this.css('font-size').slice(0, -2)) + 1) + 'px';
                $this.css('font-size', elNewFontSize);
                if(el.scrollHeight>el.clientHeight||el.scrollWidth>el.clientWidth) {
                    elNewFontSize = (parseInt($this.css('font-size').slice(0, -2)) - 1) + 'px';
                    $this.css('font-size', elNewFontSize);
                    shouldStopNow = true;
                }
            }
        });

    };

})( jQuery );