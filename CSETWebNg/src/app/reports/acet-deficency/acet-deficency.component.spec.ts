import { ComponentFixture, TestBed } from '@angular/core/testing';

import { AcetDeficencyComponent } from './acet-deficency.component';

describe('AcetDeficencyComponent', () => {
  let component: AcetDeficencyComponent;
  let fixture: ComponentFixture<AcetDeficencyComponent>;

  beforeEach(async () => {
    await TestBed.configureTestingModule({
      declarations: [ AcetDeficencyComponent ]
    })
    .compileComponents();
  });

  beforeEach(() => {
    fixture = TestBed.createComponent(AcetDeficencyComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
