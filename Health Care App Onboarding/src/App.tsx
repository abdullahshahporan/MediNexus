import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';
import IntroPage from './components/IntroPage';
import RoleSelection from './components/RoleSelection';
import DoctorSignIn from './components/DoctorSignIn';
import PatientSignIn from './components/PatientSignIn';
import PatientSignUp from './components/PatientSignUp';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<IntroPage />} />
        <Route path="/role-selection" element={<RoleSelection />} />
        <Route path="/doctor-signin" element={<DoctorSignIn />} />
        <Route path="/patient-signin" element={<PatientSignIn />} />
        <Route path="/patient-signup" element={<PatientSignUp />} />
      </Routes>
    </Router>
  );
}
