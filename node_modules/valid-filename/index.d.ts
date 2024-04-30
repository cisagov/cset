/**
Check if a string is a [valid filename](https://github.com/sindresorhus/filename-reserved-regex).

@param input - The string to check.
@returns Whether `input` is a valid filename.

@example
```
import isValidFilename from 'valid-filename';

isValidFilename('foo/bar');
//=> false

isValidFilename('foo-bar');
//=> true
```
*/
export default function isValidFilename(input: string): boolean;
