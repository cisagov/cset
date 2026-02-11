////////////////////////////////
//
//   Copyright 2026 Battelle Energy Alliance, LLC
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.
//
////////////////////////////////
import { Pipe, PipeTransform } from '@angular/core';
import { TranslocoService } from '@jsverse/transloco';


/**
 * Builds a translated string of completion.
 * 
 * The pipe can be defined as pure as long as the source object includes the current language
 * so that a language change in the Transloco service will trigger the pipe.
 */
@Pipe({
    name: 'completionCount',
    standalone: false
})
export class CompletionCountPipe implements PipeTransform {

    constructor(private tSvc: TranslocoService) { }

    transform(c: any): string {
        const disp = this.tSvc.translate(`completion-${c.qa}`, { complete: c.c, total: c.t });
        return disp;
    }
}
