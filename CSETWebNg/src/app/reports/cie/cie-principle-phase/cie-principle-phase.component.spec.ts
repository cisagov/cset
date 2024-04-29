import { ComponentFixture, TestBed } from '@angular/core/testing';

import { CiePrinciplePhaseComponent } from './cie-principle-phase.component';

describe('CiePrinciplePhaseComponent', () => {
  let component: CiePrinciplePhaseComponent;
  let fixture: ComponentFixture<CiePrinciplePhaseComponent>;

  beforeEach(() => {
    TestBed.configureTestingModule({
      declarations: [CiePrinciplePhaseComponent]
    });
    fixture = TestBed.createComponent(CiePrinciplePhaseComponent);
    component = fixture.componentInstance;
    fixture.detectChanges();
  });

  it('should create', () => {
    expect(component).toBeTruthy();
  });
});
