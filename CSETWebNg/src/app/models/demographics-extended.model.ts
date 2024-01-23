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


export interface ExtendedDemographics {
    assessmentId?: number;

    sectorId?: number;
    subSectorId?: number;

    hb7055?: string;
    hb7055Party?: string;
    hb7055Grant?: string;

    infrastructureItOt?: string;

    employees?: string;
    customersSupported?: string;
    geographicScope?: string;
    cioExists?: string;
    cisoExists?: string;
    cyberTrainingProgramExists?: string;
    cyberRiskService?: string;
}

export interface Sector {
    sectorId: number;
    sectorName: string;
    sectorHelp: string;
}

export interface Subsector {
    sectorId: number;
    subSectorId: number;
    subSectorName: string;
}

export interface Region {
    selected: boolean;
    state: string;
    regionCode: string;
    regionName: string;
    counties: County[];
}
export interface County {
    selected: boolean;
    fips: string;
    name: string;
    state: string;
    regionCode: string;
}

export interface EmployeeRange {
    id: number;
    range: string;
}

export interface CustomerRange {
    id: number;
    range: string;
}

export interface ListItem {
    id: number;
    value: string;
}


/* used for saving geographic selections */
export interface Geographics {
    regions?: GeoRegion[];
    countyFips?: string[];
    metroFips?: string[];
}

export interface GeoRegion {
    state: string;
    regionCode: string;
}