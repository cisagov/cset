import { ComponentFixture, TestBed } from '@angular/core/testing';

import { RankedDeficiencyComponent } from './ranked-deficiency.component';

describe('RankedDeficiencyComponent', () => {
  let component: RankedDeficiencyComponent;
  let fixture: ComponentFixture<RankedDeficiencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ RankedDeficiencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(RankedDeficiencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
