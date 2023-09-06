import { TestBed } from '@angular/core/testing';

import { DemographicIodService } from './demographic-iod.service';

describe('DemographicIodService', () => {
  let service: DemographicIodService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(DemographicIodService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
