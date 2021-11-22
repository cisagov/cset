import { TestBed } from '@angular/core/testing';

import { TsaService } from './tsa.service';

describe('TsaService', () => {
  let service: TsaService;

  beforeEach(() => {
    TestBed.configureTestingModule({});
    service = TestBed.inject(TsaService);
  });

  it('should be created', () => {
    expect(service).toBeTruthy();
  });
});
