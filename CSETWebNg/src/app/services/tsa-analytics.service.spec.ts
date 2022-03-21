import { TestBed } from '@angular/core/testing';

import { TsaAnalyticsService } from './tsa-analytics.service';

describe('TsaAnalyticsService', () => {
  let service: TsaAnalyticsService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TsaAnalyticsService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
