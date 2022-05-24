import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CisRankedDeficiencyComponent } from './cis-ranked-deficiency.component';

describe('CisRankedDeficiencyComponent', () => {
  let component: CisRankedDeficiencyComponent;
  let fixture: ComponentFixture<CisRankedDeficiencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ CisRankedDeficiencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(CisRankedDeficiencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
