
# bootstrap-datepicker-mobile

[![MIT License][license-image]][license-url]
[![Gratipay][gratipay-image]][gratipay-url]

> An add-on for <https://github.com/eternicode/bootstrap-datepicker> to add responsive support for mobile devices with consideration for native `input[type=date]` support using [Modernizr][modernizr] and [Moment.js][momentjs].

## Index

* [Demo](#demo)
* [Requirements](#requirements)
* [Install](#install)
* [Usage](#usage)
* [How does it work?](#how-does-it-work)
* [Tips](#tips)
* [Notes](#notes)
* [Contributors](#contributors)
* [License](#license)


## Demo

Try resizing your browser window, loading this on a mobile device, and comparing it with a desktop web-browser.  It's magical.

<http://niftylettuce.com/bootstrap-datepicker-mobile>


## Requirements

You must have the following scripts and stylesheets in the `<head>` tag of your HTML layout (please adjust paths accordingly):

```html
<html>
  <head>
    <!-- ... -->
    <link rel="stylesheet" href="/bower/bootstrap/dist/css/bootstrap.css">
    <link rel="stylesheet" href="/bower/bootstrap-datepicker/css/datepicker3.css">
    <script src="/bower/modernizr/modernizr.js"></script>
  </head>
  <!-- ... -->
</html>
```

You must have the following before the closing `</body>` tag of your HTML layout (please adjust paths accordingly):

```html
    <!-- ... -->
    <script src="/bower/jquery/dist/jquery.js"></script>
    <script src="/bower/bootstrap/dist/js/bootstrap.js"></script>
    <script src="/bower/bootstrap-datepicker/js/bootstrap-datepicker.js"></script>
    <script src="/bower/moment/moment.js"></script>
    <script src="/bower/bootstrap-datepicker-mobile/bootstrap-datepicker-mobile.js"></script>
  </body>
</html>
```

## Install

We recommend that you install into your project using [Bower][bower], but you can use [RawGit][rawgit] if needed.

### Bower

1. Install with Bower:

  ```bash
  bower install -S bootstrap-datepicker-mobile
  ```

2. Include the script in your HTML layout:

  ```html
  <script src="/bower/bootstrap-datepicker-mobile/bootstrap-datepicker-mobile.js"></script>
  ```

3. See [usage](#usage) below.

### RawGit

1. Include the script in your HTML layout:

  ```html
  <script src="//cdn.rawgit.com/niftylettuce/bootstrap-datepicker-mobile/9999ca720ebf89600bda1659c96a291dc447ff39/bootstrap-datepicker-mobile.js"></script>
  ```

2. See [usage](#usage) below.


## Usage

### Client-side

To integrate this add-on, simply follow these three rules and [use the example](#example) as a guide:

1. Always add the class of `date-picker` on date inputs to activate this add-on for the input.
2. Render dates formatted as `MM/DD/YY` for default `input` values (e.g. `<input value="02/01/99" />`).

#### Example

Here is an example of how to use this add-on for a "birthday" field with Bootstrap v3 and [Font Awesome][font-awesome]:

```html
<form action="/save-birthday" method="POST">
  <div class="form-group">
    <label class="control-label">Birthday</label>
    <div class="input-group">

      <div class="input-group-addon">
        <i class="fa fa-calendar"></i>
      </div>

      <!-- this is where the magic happens -->
      <input type="text" class="date-picker form-control" data-date-start-view="decade" data-date-format="mm/dd/yy" data-date="02/01/99" value="02/01/99" name="birthday" placeholder="MM/DD/YY" />

    </div>
  </div>
</form>
```

### Server-side

When parsing a `<form>` request body server-side, you must consider the following two possible scenarios:

* The value for an input is passed in the "MM/DD/YY" format
* The value for an input is passed in the "YYYY-MM-DD" format (if native `input[type=date]` is used)

Therefore, you should parse the date using [Moment.js][momentjs] and then store accordingly in your database.

To consider these two scenarios, here's how you might write your server-side request body parsing with JavaScript and [Node.js][nodejs]:

```js
var moment = require('moment');

app.post('/save-birthday', function(req, res, next) {

  if (typeof req.body.birthday !== 'string')
    return next(new Error('Birthday missing'));

  var nativeDateFormat = /^\d{4}-\d{2}-\d{2}$/;
  var datepickerDateFormat = /^\d{2}\/\d{2}\/\d{2}$/;

  var birthday = req.body.birthday;

  if (nativeDateFormat.test(birthday))
    birthday = moment(birthday, 'YYYY-MM-DD');
  else if (datepickerDateFormat.test(birthday))
    birthday = moment(birthday, 'MM-DD-YY');
  else
    birthday = moment(birthday);

  // save to db here or something
  next();

});
```


## How does it work?

As soon as the script is loaded, it will automatically render the page properly based on:

* If the viewport is of a mobile screen width (<= 480px wide\*)
* If the device has support for `input[type=date]` (using Modernizr via `Modernizr.inputtypes.date`)

\* This width adheres with default Bootstrap v3 `@screen-xs` value of `480px` and [mobile matrices][mobile-matrices]).

What does the add-on consider when rendering datepickers?

* It considers viewport resizing, and when resized it auto-adjusts properly via `$(window).resize` jQuery function.
* It considers whether the user was focused on an `input` when they resized (and if so, it will show the datepicker).
* It considers if the device has native support for `input[type=date]`
* It considers if the device's viewport is (<= 480px) wide (if it is mobile)


## Tips

Set the default of `autoclose` to true for a better user experience:

```js
$.fn.datepicker.defaults.autoclose = true;
```


## Notes

Currently we assume that you pre-populate your date `input`'s with the format of `MM/DD/YY`.  If you have the date formatted any other way, this add-on will not work properly.

If you'd like to add support other formats than `MM-DD-YY` (e.g. some sort of configuration options setup), then please submit a pull request.

We highly recommend using [Moment.js][momentjs] for working with dates (both server-side and client-side).

This project also supports the native [RFC 3339][rfc-3339] format of `YYYY-MM-DD` when `input[type=date]`'s are initiated.


## Contributors

* [Nick Baugh](https://github.com/niftylettuce)


## License

[MIT][license-url]


[bower]: http://bower.io
[rawgit]: http://rawgit.com
[bootstrap-datepicker]: https://github.com/eternicode/bootstrap-datepicker
[momentjs]: http://momentjs.com
[modernizr]: http://modernizr.com
[rfc-3339]: https://www.ietf.org/rfc/rfc3339.txt
[mobile-matrices]: https://github.com/h5bp/mobile-boilerplate/wiki/Mobile-Matrices
[font-awesome]: http://fontawesome.io
[license-image]: https://img.shields.io/badge/license-MIT-blue.svg?style=flat
[license-url]: LICENSE
[gratipay-image]: https://img.shields.io/gratipay/niftylettuce.svg?style=flat
[gratipay-url]: https://gratipay.com/niftylettuce
[nodejs]: http://nodejs.org
