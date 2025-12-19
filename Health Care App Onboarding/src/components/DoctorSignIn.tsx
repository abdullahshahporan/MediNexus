import { useState } from 'react';
import { motion } from 'motion/react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, FileText, Camera, CheckCircle } from 'lucide-react';
import logo from 'figma:asset/67deb029e390c772cc33e8e748e86b0188280ecc.png';

export default function DoctorSignIn() {
  const navigate = useNavigate();
  const [step, setStep] = useState<'license' | 'verification'>('license');
  const [license, setLicense] = useState('');
  const [licenseFile, setLicenseFile] = useState<string | null>(null);
  const [verificationStarted, setVerificationStarted] = useState(false);

  const handleFileUpload = (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (file) {
      setLicenseFile(file.name);
    }
  };

  const handleLicenseSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (license && licenseFile) {
      setStep('verification');
    }
  };

  const startVerification = () => {
    setVerificationStarted(true);
    // Simulate verification process
    setTimeout(() => {
      alert('Verification successful! Welcome, Doctor.');
    }, 2000);
  };

  return (
    <div className="min-h-screen bg-black flex items-center justify-center p-6 relative overflow-hidden">
      {/* Background logo with blur and 3D effect */}
      <div className="absolute inset-0 flex items-center justify-center">
        <motion.div
          animate={{
            scale: [1, 1.05, 1],
            rotateY: [0, 5, 0],
          }}
          transition={{
            duration: 8,
            repeat: Infinity,
            ease: "easeInOut",
          }}
          className="opacity-5 blur-md"
          style={{ transform: 'perspective(1000px)' }}
        >
          <img src={logo} alt="" className="w-[700px] h-auto" />
        </motion.div>
      </div>

      {/* Grid overlay */}
      <div className="absolute inset-0 opacity-5">
        <div className="w-full h-full" style={{
          backgroundImage: 'linear-gradient(rgba(255,255,255,0.05) 1px, transparent 1px), linear-gradient(90deg, rgba(255,255,255,0.05) 1px, transparent 1px)',
          backgroundSize: '50px 50px'
        }} />
      </div>

      <motion.div
        initial={{ opacity: 0, y: 20 }}
        animate={{ opacity: 1, y: 0 }}
        className="relative z-10 w-full max-w-md"
      >
        {/* Back button */}
        <button
          onClick={() => navigate('/role-selection')}
          className="mb-6 flex items-center gap-2 text-gray-400 hover:text-white transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back
        </button>

        {/* Glass card */}
        <div className="rounded-3xl border border-white/10 backdrop-blur-2xl bg-white/5 p-8 shadow-2xl">
          {/* Header */}
          <div className="text-center mb-8">
            <h2 className="text-white mb-2">Doctor Sign In</h2>
            <p className="text-gray-400">Verification required for medical professionals</p>
          </div>

          {/* Step indicator */}
          <div className="flex items-center justify-center gap-4 mb-8">
            <div className="flex items-center gap-2">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center ${step === 'license' ? 'bg-white text-black' : 'bg-white/20 text-white'}`}>
                1
              </div>
              <span className="text-gray-400 text-sm">License</span>
            </div>
            <div className="w-16 h-[1px] bg-white/20" />
            <div className="flex items-center gap-2">
              <div className={`w-8 h-8 rounded-full flex items-center justify-center ${step === 'verification' ? 'bg-white text-black' : 'bg-white/20 text-white'}`}>
                2
              </div>
              <span className="text-gray-400 text-sm">Verification</span>
            </div>
          </div>

          {/* License Form */}
          {step === 'license' && (
            <motion.form
              initial={{ opacity: 0, x: -20 }}
              animate={{ opacity: 1, x: 0 }}
              onSubmit={handleLicenseSubmit}
              className="space-y-6"
            >
              <div>
                <label className="block text-gray-300 mb-2 text-sm">Medical License Number</label>
                <input
                  type="text"
                  value={license}
                  onChange={(e) => setLicense(e.target.value)}
                  placeholder="Enter your license number"
                  className="w-full px-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                  required
                />
              </div>

              <div>
                <label className="block text-gray-300 mb-2 text-sm">Upload License Document</label>
                <div className="relative">
                  <input
                    type="file"
                    onChange={handleFileUpload}
                    className="hidden"
                    id="license-upload"
                    accept=".pdf,.jpg,.jpeg,.png"
                    required
                  />
                  <label
                    htmlFor="license-upload"
                    className="flex items-center justify-center gap-3 w-full px-4 py-6 rounded-xl bg-white/5 border border-white/10 border-dashed text-gray-400 hover:bg-white/10 transition-colors cursor-pointer"
                  >
                    <FileText className="w-5 h-5" />
                    {licenseFile ? licenseFile : 'Choose file to upload'}
                  </label>
                </div>
                {licenseFile && (
                  <div className="flex items-center gap-2 mt-2 text-green-400 text-sm">
                    <CheckCircle className="w-4 h-4" />
                    File uploaded successfully
                  </div>
                )}
              </div>

              <button
                type="submit"
                className="w-full py-4 rounded-xl bg-white text-black hover:bg-gray-200 transition-colors"
              >
                Continue to Verification
              </button>
            </motion.form>
          )}

          {/* Face Verification */}
          {step === 'verification' && (
            <motion.div
              initial={{ opacity: 0, x: 20 }}
              animate={{ opacity: 1, x: 0 }}
              className="space-y-6"
            >
              <div className="text-center">
                <div className="w-full aspect-video rounded-2xl bg-white/5 border border-white/10 flex items-center justify-center mb-4 overflow-hidden relative">
                  {verificationStarted ? (
                    <motion.div
                      animate={{
                        scale: [1, 1.1, 1],
                      }}
                      transition={{
                        duration: 2,
                        repeat: Infinity,
                      }}
                      className="text-center"
                    >
                      <div className="w-32 h-32 rounded-full border-4 border-white/20 border-t-white animate-spin mx-auto mb-4" />
                      <p className="text-gray-300">Verifying your identity...</p>
                    </motion.div>
                  ) : (
                    <div className="text-center">
                      <Camera className="w-16 h-16 text-gray-400 mx-auto mb-4" />
                      <p className="text-gray-300">Position your face in the frame</p>
                    </div>
                  )}
                </div>
              </div>

              {!verificationStarted ? (
                <>
                  <div className="space-y-2 text-sm text-gray-400">
                    <p>• Ensure good lighting</p>
                    <p>• Remove glasses if wearing any</p>
                    <p>• Look directly at the camera</p>
                  </div>

                  <button
                    onClick={startVerification}
                    className="w-full py-4 rounded-xl bg-white text-black hover:bg-gray-200 transition-colors"
                  >
                    Start Face Verification
                  </button>

                  <button
                    onClick={() => setStep('license')}
                    className="w-full py-4 rounded-xl bg-white/5 text-white hover:bg-white/10 transition-colors"
                  >
                    Back to License
                  </button>
                </>
              ) : null}
            </motion.div>
          )}
        </div>
      </motion.div>
    </div>
  );
}
