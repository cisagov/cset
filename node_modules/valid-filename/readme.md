# valid-filename

> Check if a string is a [valid filename](https://github.com/sindresorhus/filename-reserved-regex)

## Install

```
$ npm install valid-filename
```

## Usage

```js
import isValidFilename from 'valid-filename';

isValidFilename('foo/bar');
//=> false

isValidFilename('foo-bar');
//=> true
```

## API

### isValidFilename(input)

Returns a `boolean` of whether `input` is a valid filename.

#### input

Type: `string`

The string to check.

## Related

- [filenamify](https://github.com/sindresorhus/filenamify) - Convert a string to a valid safe filename
