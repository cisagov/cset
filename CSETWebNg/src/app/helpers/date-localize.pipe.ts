////////////////////////////////
//
//   Copyright 2024 Battelle Energy Alliance, LLC
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
import { TranslocoService } from '@ngneat/transloco';
import { DateTime } from 'luxon';
import { JwtParser } from './jwt-parser';
import { AuthenticationService } from '../services/authentication.service';

/**
 * Formats a date to the 'local' style, based on the locale
 * currently set in the TranslocoService.
 */
@Pipe({ name: 'localizeDate' })
export class LocalizeDatePipe implements PipeTransform {

    constructor(
        private tSvc: TranslocoService,
        private authSvc: AuthenticationService
    ) { }

    /**
     *
     */
    transform(dateString: string, arg1): string {
        if (!dateString) {
            return '';
        }

        // localize the datetime
        let dt: DateTime = DateTime.fromISO(dateString);
        dt = dt.setLocale(this.tSvc.getActiveLang());

        // return a full string with timezone offset
        if (arg1?.toLowerCase() == 'gmt') {
            return dt.toLocaleString(DateTime.DATETIME_SHORT_WITH_SECONDS) + ' GMT-' + this.getOffsetFromJwtToken();
        }

        // the caller specified a date format
        if (!!arg1) {
            return dt.toFormat(arg1);
        }

        // default to the localized numeric date (en-US would be M/D/YYYY)
        return dt.toLocaleString(DateTime.DATE_SHORT);
    }

    /**
     *
     */
    getOffsetFromJwtToken() {
        const jwt = new JwtParser();
        const parsedToken = jwt.decodeToken(this.authSvc.userToken());
        let offset = (parsedToken.tzoffset / 60) * 100;
        let gmtString = offset.toString();

        if (gmtString.length < 4) {
            gmtString = '0' + gmtString;
        }
        return gmtString;
    }
}
