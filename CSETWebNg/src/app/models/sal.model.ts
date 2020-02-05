////////////////////////////////
//
//   Copyright 2020 Battelle Energy Alliance, LLC
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
export class Sal {
    AssessmentName: string;
    Application_Mode: string;
    Selected_Sal_Level: string;
    Last_Sal_Determination_Type: string;
    Sort_Set_Name: string;
    CLevel: string;
    ILevel: string;
    ALevel: string;
    SelectedSALOverride: boolean;
}

export interface GenSalWeights {
    Sal_Weight_Id: number;
    Sal_Name: string;
    Slider_Value: number;
    Weight: number;
    Display: string;
}

export interface GeneralSalDescriptionsWeights {
    Sal_Name: string;
    Sal_Description: string;
    Sal_Order: number;
    min: number;
    max: number;
    step: number;
    GEN_SAL_WEIGHTS: GenSalWeights[];
    prefix: string;
    postfix: string;
    values: string[];
    Slider_Value: number;
}
