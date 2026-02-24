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
export interface TooltipOptions {
    'placement'?: string;
    'autoPlacement'?: boolean;
    'content-type'?: 'string' | 'html' | 'template';
    'contentType'?: 'string' | 'html' | 'template';
    'delay'?: number;
    'show-delay'?: number;
    'showDelay'?: number;
    'hide-delay'?: number;
    'hideDelay'?: number;
    'hide-delay-mobile'?: number;
    'hideDelayMobile'?: number;
    'hideDelayTouchscreen'?: number;
    'z-index'?: number;
    'zIndex'?: number;
    'animation-duration'?: number;
    'animationDuration'?: number;
    'animation-duration-default'?: number;
    'animationDurationDefault'?: number;
    'trigger'?: string;
    'tooltip-class'?: string;
    'tooltipClass'?: string;
    'display'?: boolean;
    'display-mobile'?: boolean;
    'displayMobile'?: boolean;
    'displayTouchscreen'?: boolean;
    'shadow'?: boolean;
    'theme'?: "dark" | "light";
    'offset'?: number;
    'width'?: string;
    'max-width'?: string;
    'maxWidth'?: string;
    'id'?: string | number;
    'hideDelayAfterClick'?: number;
    'pointerEvents'?: 'auto' | 'none';
    'position'?: {top: number, left: number};
}