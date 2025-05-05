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
