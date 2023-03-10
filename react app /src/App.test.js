import { render, screen, waitFor } from '@testing-library/react';
import App from './App';

test('render', async () => {
  render(<App />);

  await waitFor(() => {
    expect(screen.getByText(/Create React Ethereum DApp/i)).toBeInTheDocument();
  });
  expect(screen.getByText(/active:/i)).toBeInTheDocument();
  expect(
    screen.getByRole('button', { name: 'Connect Wallet' })
  ).toBeInTheDocument();
 
});
