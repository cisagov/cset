export interface NameSeries {
     name: string,
     series: NameValue[]
}


export interface NameValue {
     name: string,
     value: string
}


export interface ScoredDomainDistrib {
     distrib: NameSeries[],
     score: number
}