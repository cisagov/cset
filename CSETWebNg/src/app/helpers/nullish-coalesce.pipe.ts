import { Pipe, PipeTransform } from '@angular/core';

/*
 * Applies Nullish Coalescing to the value (Provides typescripts ?? operator like functionality in templates)
 * Takes an fallback value argument.
 * Usage:
 *   value | nullishCoalesce:fallbackValue
 * Example:
 *   {{ null | nullishCoalesce:'some fallback value' }}
 *   formats to: 'some fallback value'
 */
@Pipe({
  name: 'nullishCoalesce',
})
export class NullishCoalescePipe implements PipeTransform {
  transform<T, K>(value: T, fallbackValue: K): NonNullable<T> | K {
    return value != null ? (value as NonNullable<T>) : fallbackValue;
  }
}
