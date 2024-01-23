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
import { Injectable } from '@angular/core';
import { HttpResponseBase, HttpResponse, HttpErrorResponse } from '@angular/common/http';

@Injectable()
export class Utilities {
    public static readonly captionAndMessageSeparator = ':';
    public static readonly noNetworkMessageCaption = 'No Network';
    public static readonly noNetworkMessageDetail = 'The server cannot be reached';
    public static readonly accessDeniedMessageCaption = 'Access Denied!';
    public static readonly accessDeniedMessageDetail = '';
    public static readonly notFoundMessageCaption = 'Not Found';
    public static readonly notFoundMessageDetail = 'The target resource cannot be found';

    public static cookies =
        {
            getItem: (sKey) => {
                return decodeURIComponent(document.cookie.replace(new RegExp('(?:(?:^|.*;)\\s*' + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, '\\$&') + '\\s*\\=\\s*([^;]*).*$)|^.*$'), '$1')) || null;
            },
            setItem: (sKey, sValue, vEnd, sPath, sDomain, bSecure) => {
                if (!sKey || /^(?:expires|max\-age|path|domain|secure)$/i.test(sKey)) {
                    return false;
                }

                let sExpires = '';

                if (vEnd) {
                    switch (vEnd.constructor) {
                        case Number:
                            sExpires = vEnd === Infinity ? '; expires=Fri, 31 Dec 9999 23:59:59 GMT' : '; max-age=' + vEnd;
                            break;
                        case String:
                            sExpires = '; expires=' + vEnd;
                            break;
                        case Date:
                            sExpires = '; expires=' + vEnd.toUTCString();
                            break;
                    }
                }

                document.cookie = encodeURIComponent(sKey) + '=' + encodeURIComponent(sValue) + sExpires + (sDomain ? '; domain=' + sDomain : '') + (sPath ? '; path=' + sPath : '') + (bSecure ? '; secure' : '');
                return true;
            },
            removeItem: (sKey, sPath, sDomain) => {
                if (!sKey) {
                    return false;
                }
                document.cookie = encodeURIComponent(sKey) + '=; expires=Thu, 01 Jan 1970 00:00:00 GMT' + (sDomain ? '; domain=' + sDomain : '') + (sPath ? '; path=' + sPath : '');
                return true;
            },
            hasItem: (sKey) => {
                return (new RegExp('(?:^|;\\s*)' + encodeURIComponent(sKey).replace(/[\-\.\+\*]/g, '\\$&') + '\\s*\\=')).test(document.cookie);
            },
            keys: () => {
                const aKeys = document.cookie.replace(/((?:^|\s*;)[^\=]+)(?=;|$)|^\s*|\s*(?:\=[^;]*)?(?:\1|$)/g, '').split(/\s*(?:\=[^;]*)?;\s*/);
                for (let nIdx = 0; nIdx < aKeys.length; nIdx++) { aKeys[nIdx] = decodeURIComponent(aKeys[nIdx]); }
                return aKeys;
            }
        };

    public static getHttpResponseMessages(data: HttpResponseBase | any): string[] {
        const responses: string[] = [];

        if (data instanceof HttpResponseBase) {
            if (this.checkNoNetwork(data)) {
                responses.push(`${this.noNetworkMessageCaption}${this.captionAndMessageSeparator} ${this.noNetworkMessageDetail}`);
            } else {
                const responseObject = this.getResponseBody(data);

                if (responseObject && (typeof responseObject === 'object' || responseObject instanceof Object)) {

                    for (const key in responseObject) {
                        if (key) {
                            responses.push(`${key}${this.captionAndMessageSeparator} ${responseObject[key]}`);
                        } else if (responseObject[key]) {
                            responses.push(responseObject[key].toString());
                        }
                    }
                }
            }

            if (!responses.length) {
                if ((data as any).body) {
                    responses.push(`body: ${(data as any).body}`);
                }

                if ((data as any).error) {
                    responses.push(`error: ${(data as any).error}`);
                }
            }
        }

        if (!responses.length) {
            if (this.getResponseBody(data)) {
                responses.push(this.getResponseBody(data).toString());
            } else {
                responses.push(data.toString());
            }
        }

        if (this.checkAccessDenied(data)) {
            responses.splice(0, 0, `${this.accessDeniedMessageCaption}${this.captionAndMessageSeparator} ${this.accessDeniedMessageDetail}`);
        }

        if (this.checkNotFound(data)) {
            let message = `${this.notFoundMessageCaption}${this.captionAndMessageSeparator} ${this.notFoundMessageDetail}`;
            if (data.url) {
                message += `. ${data.url}`;
            }

            responses.splice(0, 0, message);
        }

        return responses;
    }

    public static getHttpResponseMessage(data: HttpResponseBase | any): string {
        const httpMessage =
            Utilities.findHttpResponseMessage(Utilities.noNetworkMessageCaption, data) ||
            Utilities.findHttpResponseMessage(Utilities.notFoundMessageCaption, data) ||
            Utilities.findHttpResponseMessage('error_description', data) ||
            Utilities.findHttpResponseMessage('error', data) ||
            Utilities.getHttpResponseMessages(data).join();

        return httpMessage;
    }

    public static findHttpResponseMessage(messageToFind: string, data: HttpResponse<any> | any, seachInCaptionOnly = true, includeCaptionInResult = false): string {
        const searchString = messageToFind.toLowerCase();
        const httpMessages = this.getHttpResponseMessages(data);

        for (const message of httpMessages) {
            const fullMessage = Utilities.splitInTwo(message, this.captionAndMessageSeparator);

            if (fullMessage.firstPart && fullMessage.firstPart.toLowerCase().indexOf(searchString) != -1) {
                return includeCaptionInResult ? message : fullMessage.secondPart || fullMessage.firstPart;
            }
        }

        if (!seachInCaptionOnly) {
            for (const message of httpMessages) {

                if (message.toLowerCase().indexOf(searchString) != -1) {
                    if (includeCaptionInResult) {
                        return message;
                    } else {
                        const fullMessage = Utilities.splitInTwo(message, this.captionAndMessageSeparator);
                        return fullMessage.secondPart || fullMessage.firstPart;
                    }
                }
            }
        }

        return null;
    }

    public static getResponseBody(response: HttpResponseBase) {
        if (response instanceof HttpResponse) {
            return response.body;
        }

        if (response instanceof HttpErrorResponse) {
            return response.error || response.message || response.statusText;
        }
    }

    public static checkNoNetwork(response: HttpResponseBase) {
        if (response instanceof HttpResponseBase) {
            return response.status == 0;
        }

        return false;
    }

    public static checkAccessDenied(response: HttpResponseBase) {
        if (response instanceof HttpResponseBase) {
            return response.status == 403;
        }

        return false;
    }

    public static checkNotFound(response: HttpResponseBase) {
        if (response instanceof HttpResponseBase) {
            return response.status == 404;
        }

        return false;
    }

    public static checkIsLocalHost(url: string, base?: string) {
        if (url) {
            const location = new URL(url, base);
            return location.hostname === 'localhost' || location.hostname === '127.0.0.1';
        }

        return false;
    }

    public static getQueryParamsFromString(paramString: string) {
        if (!paramString) {
            return null;
        }

        const params: { [key: string]: string } = {};

        for (const param of paramString.split('&')) {
            const keyValue = Utilities.splitInTwo(param, '=');
            params[keyValue.firstPart] = keyValue.secondPart;
        }

        return params;
    }

    public static splitInTwo(text: string, separator: string): { firstPart: string, secondPart: string } {
        const separatorIndex = text.indexOf(separator);

        if (separatorIndex == -1) {
            return { firstPart: text, secondPart: null };
        }

        const part1 = text.substr(0, separatorIndex).trim();
        const part2 = text.substr(separatorIndex + 1).trim();

        return { firstPart: part1, secondPart: part2 };
    }

    public static safeStringify(object) {

        let result: string;

        try {
            result = JSON.stringify(object);
            return result;
        } catch (error) {

        }

        const simpleObject = {};

        for (const prop in object) {
            if (!object.hasOwnProperty(prop)) {
                continue;
            }
            if (typeof (object[prop]) == 'object') {
                continue;
            }
            if (typeof (object[prop]) == 'function') {
                continue;
            }
            simpleObject[prop] = object[prop];
        }

        result = '[***Sanitized Object***]: ' + JSON.stringify(simpleObject);

        return result;
    }

    public static JsonTryParse(value: string) {
        try {
            return JSON.parse(value);
        } catch (e) {
            if (value === 'undefined') {
                return void 0;
            }
            return value;
        }
    }

    public static TestIsObjectEmpty(obj: any) {
        for (const prop in obj) {
            if (obj.hasOwnProperty(prop)) {
                return false;
            }
        }

        return true;
    }

    public static TestIsUndefined(value: any) {
        return typeof value === 'undefined';
        // return value === undefined;
    }

    public static TestIsString(value: any) {
        return typeof value === 'string' || value instanceof String;
    }

    public static capitalizeFirstLetter(text: string) {
        if (text) {
            return text.charAt(0).toUpperCase() + text.slice(1);
        } else {
            return text;
        }
    }

    public static toTitleCase(text: string) {
        return text.replace(/\w\S*/g, (subString) => {
            return subString.charAt(0).toUpperCase() + subString.substr(1).toLowerCase();
        });
    }

    public static toLowerCase(items: string);
    public static toLowerCase(items: string[]);
    public static toLowerCase(items: any): string | string[] {

        if (items instanceof Array) {
            const loweredRoles: string[] = [];

            for (let i = 0; i < items.length; i++) {
                loweredRoles[i] = items[i].toLowerCase();
            }

            return loweredRoles;
        } else if (typeof items === 'string' || items instanceof String) {
            return items.toLowerCase();
        }
    }

    public static uniqueId() {
        return this.randomNumber(1000000, 9000000).toString();
    }

    public static randomNumber(min: number, max: number) {
        return Math.floor(Math.random() * (max - min + 1) + min);
    }

    public static baseUrl() {
        let base = '';

        if (window.location.origin) {
            base = window.location.origin;
        } else {
            base = window.location.protocol + '//' + window.location.hostname + (window.location.port ? ':' + window.location.port : '');
        }

        return base.replace(/\/$/, '');
    }

    public static printDateOnly(date: Date) {

        date = new Date(date);

        const dayNames = new Array('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
        const monthNames = new Array('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');

        const dayOfWeek = date.getDay();
        const dayOfMonth = date.getDate();
        let sup = '';
        const month = date.getMonth();
        const year = date.getFullYear();

        if (dayOfMonth == 1 || dayOfMonth == 21 || dayOfMonth == 31) {
            sup = 'st';
        } else if (dayOfMonth == 2 || dayOfMonth == 22) {
            sup = 'nd';
        } else if (dayOfMonth == 3 || dayOfMonth == 23) {
            sup = 'rd';
        } else {
            sup = 'th';
        }

        const dateString = dayNames[dayOfWeek] + ', ' + dayOfMonth + sup + ' ' + monthNames[month] + ' ' + year;

        return dateString;
    }

    public static printTimeOnly(date: Date) {

        date = new Date(date);

        let period = '';
        let minute = date.getMinutes().toString();
        let hour = date.getHours();

        period = hour < 12 ? 'AM' : 'PM';

        if (hour == 0) {
            hour = 12;
        }
        if (hour > 12) {
            hour = hour - 12;
        }

        if (minute.length == 1) {
            minute = '0' + minute;
        }

        const timeString = hour + ':' + minute + ' ' + period;


        return timeString;
    }

    public static printDate(date: Date, separator = 'at') {
        return `${Utilities.printDateOnly(date)} ${separator} ${Utilities.printTimeOnly(date)}`;
    }

    public static printFriendlyDate(date: Date, separator = '-') {
        const today = new Date(); today.setHours(0, 0, 0, 0);
        const yesterday = new Date(today); yesterday.setDate(yesterday.getDate() - 1);
        const test = new Date(date.getFullYear(), date.getMonth(), date.getDate());

        if (test.toDateString() == today.toDateString()) {
            return `Today ${separator} ${Utilities.printTimeOnly(date)}`;
        }
        if (test.toDateString() == yesterday.toDateString()) {
            return `Yesterday ${separator} ${Utilities.printTimeOnly(date)}`;
        } else {
            return Utilities.printDate(date, separator);
        }
    }

    public static printShortDate(date: Date, separator = '/', dateTimeSeparator = '-') {

        let day = date.getDate().toString();
        let month = (date.getMonth() + 1).toString();
        const year = date.getFullYear();

        if (day.length == 1) {
            day = '0' + day;
        }

        if (month.length == 1) {
            month = '0' + month;
        }

        return `${month}${separator}${day}${separator}${year} ${dateTimeSeparator} ${Utilities.printTimeOnly(date)}`;
    }

    public static parseDate(date) {

        if (date) {

            if (date instanceof Date) {
                return date;
            }

            if (typeof date === 'string' || date instanceof String) {
                if (date.search(/[a-su-z+]/i) == -1) {
                    date = date + 'Z';
                }

                return new Date(date);
            }

            if (typeof date === 'number' || date instanceof Number) {
                return new Date(date as any);
            }
        }
    }

    public static printDuration(start: Date, end: Date) {

        start = new Date(start);
        end = new Date(end);

        // get total seconds between the times
        let delta = Math.abs(start.valueOf() - end.valueOf()) / 1000;

        // calculate (and subtract) whole days
        const days = Math.floor(delta / 86400);
        delta -= days * 86400;

        // calculate (and subtract) whole hours
        const hours = Math.floor(delta / 3600) % 24;
        delta -= hours * 3600;

        // calculate (and subtract) whole minutes
        const minutes = Math.floor(delta / 60) % 60;
        delta -= minutes * 60;

        // what's left is seconds
        const seconds = delta % 60;  // in theory the modulus is not required


        let printedDays = '';

        if (days) {
            printedDays = `${days} days`;
        }

        if (hours) {
            printedDays += printedDays ? `, ${hours} hours` : `${hours} hours`;
        }

        if (minutes) {
            printedDays += printedDays ? `, ${minutes} minutes` : `${minutes} minutes`;
        }

        if (seconds) {
            printedDays += printedDays ? ` and ${seconds} seconds` : `${seconds} seconds`;
        }


        if (!printedDays) {
            printedDays = '0';
        }

        return printedDays;
    }

    public static getAge(birthDate, otherDate) {
        birthDate = new Date(birthDate);
        otherDate = new Date(otherDate);

        let years = (otherDate.getFullYear() - birthDate.getFullYear());

        if (otherDate.getMonth() < birthDate.getMonth() ||
            otherDate.getMonth() == birthDate.getMonth() && otherDate.getDate() < birthDate.getDate()) {
            years--;
        }

        return years;
    }

    public static searchArray(searchTerm: string, caseSensitive: boolean, ...values: any[]) {
        if (!searchTerm) {
            return true;
        }

        let filter = searchTerm.trim();
        let data = values.join();

        if (!caseSensitive) {
            filter = filter.toLowerCase();
            data = data.toLowerCase();
        }

        return data.indexOf(filter) != -1;
    }

    public static moveArrayItem(array: any[], oldIndex, newIndex) {

        if (oldIndex < 0) {
            return;
        }

        if (newIndex < 0) {
            newIndex += array.length;
        }

        if (newIndex >= array.length) {
            let k = newIndex - array.length;
            while ((k--) + 1) {
                array.push(undefined);
            }
        }

        array.splice(newIndex, 0, array.splice(oldIndex, 1)[0]);
    }

    public static expandCamelCase(text: string) {

        if (!text) {
            return text;
        }

        return text.replace(/([A-Z][a-z]+)/g, ' $1')
            .replace(/([A-Z][A-Z]+)/g, ' $1')
            .replace(/([^A-Za-z ]+)/g, ' $1');
    }

    public static testIsAbsoluteUrl(url: string) {

        const r = new RegExp('^(?:[a-z]+:)?//', 'i');
        return r.test(url);
    }

    public static convertToAbsoluteUrl(url: string) {

        return Utilities.testIsAbsoluteUrl(url) ? url : '//' + url;
    }

    // public static removeNulls(obj) {
    //     const isArray = obj instanceof Array;

    //     for (const k in obj) {
    //         if (obj[k] === null) {
    //             isArray ? obj.splice(k, 1) : delete obj[k];
    //         } else if (typeof obj[k] == 'object') {
    //             Utilities.removeNulls(obj[k]);
    //         }

    //         if (isArray && obj.length == k) {
    //             Utilities.removeNulls(obj);
    //         }
    //     }

    //     return obj;
    // }

    public static debounce(func: (...args) => any, wait: number, immediate?: boolean) {
        let timeout;

        return function () {
            const context = this;
            const args_ = arguments;

            const later = function () {
                timeout = null;
                if (!immediate) {
                    func.apply(context, args_);
                }
            };

            const callNow = immediate && !timeout;

            clearTimeout(timeout);
            timeout = setTimeout(later, wait);

            if (callNow) {
                func.apply(context, args_);
            }
        };
    }

    public static getValueAtIndexOrDefault(value, index, defaultValue) {
        let isArray = false;
        if (Array.isArray(value)) {
            isArray = true;
        }

        if (isArray) {
            return typeof value[index] === 'undefined' ? defaultValue : value[index];
        }
        return typeof value === 'undefined' ? defaultValue : value;
    }

    /**
     * Returns a random alphanumeric string of the desired length.
     */
    public makeId(length) {
        var result = '';
        var characters = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789';
        var charactersLength = characters.length;
        for (var i = 0; i < length; i++) {
            result += characters.charAt(Math.floor(Math.random() *
                charactersLength));
        }
        return result;
    }
}
