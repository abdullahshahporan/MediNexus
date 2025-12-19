import { useState } from 'react';
import { motion } from 'motion/react';
import { useNavigate } from 'react-router-dom';
import { ArrowLeft, User, Mail, Lock, Phone, Calendar } from 'lucide-react';
import logo from 'figma:asset/67deb029e390c772cc33e8e748e86b0188280ecc.png';

export default function PatientSignUp() {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    name: '',
    age: '',
    gender: '',
    mobile: '',
    email: '',
    password: '',
    confirmPassword: '',
    bloodGroup: '',
    address: '',
  });

  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement | HTMLTextAreaElement>) => {
    setFormData({
      ...formData,
      [e.target.name]: e.target.value,
    });
  };

  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    if (formData.password !== formData.confirmPassword) {
      alert('Passwords do not match!');
      return;
    }
    alert('Account created successfully! Welcome to Medi Nexus.');
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
        className="relative z-10 w-full max-w-2xl my-8"
      >
        {/* Back button */}
        <button
          onClick={() => navigate('/patient-signin')}
          className="mb-6 flex items-center gap-2 text-gray-400 hover:text-white transition-colors"
        >
          <ArrowLeft className="w-5 h-5" />
          Back to Sign In
        </button>

        {/* Glass card */}
        <div className="rounded-3xl border border-white/10 backdrop-blur-2xl bg-white/5 p-8 shadow-2xl">
          {/* Header */}
          <div className="text-center mb-8">
            <h2 className="text-white mb-2">Create Patient Account</h2>
            <p className="text-gray-400">Fill in your details to get started</p>
          </div>

          {/* Form */}
          <form onSubmit={handleSubmit} className="space-y-6">
            {/* Personal Information */}
            <div className="space-y-4">
              <h3 className="text-white text-sm">Personal Information</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Full Name</label>
                  <div className="relative">
                    <User className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="text"
                      name="name"
                      value={formData.name}
                      onChange={handleChange}
                      placeholder="Enter your full name"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Age</label>
                  <div className="relative">
                    <Calendar className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="number"
                      name="age"
                      value={formData.age}
                      onChange={handleChange}
                      placeholder="Enter your age"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>
              </div>

              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Gender</label>
                  <select
                    name="gender"
                    value={formData.gender}
                    onChange={handleChange}
                    className="w-full px-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-white/30 transition-colors"
                    required
                  >
                    <option value="" className="bg-gray-900">Select gender</option>
                    <option value="male" className="bg-gray-900">Male</option>
                    <option value="female" className="bg-gray-900">Female</option>
                    <option value="other" className="bg-gray-900">Other</option>
                  </select>
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Blood Group</label>
                  <select
                    name="bloodGroup"
                    value={formData.bloodGroup}
                    onChange={handleChange}
                    className="w-full px-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white focus:outline-none focus:border-white/30 transition-colors"
                    required
                  >
                    <option value="" className="bg-gray-900">Select blood group</option>
                    <option value="A+" className="bg-gray-900">A+</option>
                    <option value="A-" className="bg-gray-900">A-</option>
                    <option value="B+" className="bg-gray-900">B+</option>
                    <option value="B-" className="bg-gray-900">B-</option>
                    <option value="AB+" className="bg-gray-900">AB+</option>
                    <option value="AB-" className="bg-gray-900">AB-</option>
                    <option value="O+" className="bg-gray-900">O+</option>
                    <option value="O-" className="bg-gray-900">O-</option>
                  </select>
                </div>
              </div>
            </div>

            {/* Contact Information */}
            <div className="space-y-4">
              <h3 className="text-white text-sm">Contact Information</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Mobile Number</label>
                  <div className="relative">
                    <Phone className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="tel"
                      name="mobile"
                      value={formData.mobile}
                      onChange={handleChange}
                      placeholder="Enter mobile number"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Email</label>
                  <div className="relative">
                    <Mail className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="email"
                      name="email"
                      value={formData.email}
                      onChange={handleChange}
                      placeholder="Enter email address"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>
              </div>

              <div>
                <label className="block text-gray-300 mb-2 text-sm">Address</label>
                <textarea
                  name="address"
                  value={formData.address}
                  onChange={handleChange}
                  placeholder="Enter your address"
                  rows={2}
                  className="w-full px-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors resize-none"
                  required
                />
              </div>
            </div>

            {/* Security */}
            <div className="space-y-4">
              <h3 className="text-white text-sm">Security</h3>
              
              <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Password</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="password"
                      name="password"
                      value={formData.password}
                      onChange={handleChange}
                      placeholder="Create password"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>

                <div>
                  <label className="block text-gray-300 mb-2 text-sm">Confirm Password</label>
                  <div className="relative">
                    <Lock className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-gray-400" />
                    <input
                      type="password"
                      name="confirmPassword"
                      value={formData.confirmPassword}
                      onChange={handleChange}
                      placeholder="Confirm password"
                      className="w-full pl-12 pr-4 py-3 rounded-xl bg-white/5 border border-white/10 text-white placeholder-gray-500 focus:outline-none focus:border-white/30 transition-colors"
                      required
                    />
                  </div>
                </div>
              </div>
            </div>

            {/* Terms */}
            <div>
              <label className="flex items-start gap-3 text-gray-400 cursor-pointer text-sm">
                <input
                  type="checkbox"
                  className="w-4 h-4 mt-1 rounded bg-white/5 border border-white/10 focus:outline-none"
                  required
                />
                <span>
                  I agree to the Terms of Service and Privacy Policy
                </span>
              </label>
            </div>

            <button
              type="submit"
              className="w-full py-4 rounded-xl bg-white text-black hover:bg-gray-200 transition-colors"
            >
              Create Account
            </button>
          </form>

          {/* Sign in link */}
          <div className="text-center mt-6">
            <p className="text-gray-400 text-sm">
              Already have an account?{' '}
              <button
                onClick={() => navigate('/patient-signin')}
                className="text-white hover:underline"
              >
                Sign In
              </button>
            </p>
          </div>
        </div>
      </motion.div>
    </div>
  );
}
